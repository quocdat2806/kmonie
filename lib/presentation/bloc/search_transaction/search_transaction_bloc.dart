import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/error/failure.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'search_transaction_event.dart';
import 'search_transaction_state.dart';

class SearchTransactionBloc extends Bloc<SearchTransactionEvent, SearchTransactionState> {
  final TransactionRepository transactionRepository;
  final TransactionCategoryRepository categoryRepository;
  StreamSubscription<AppStreamData>? _subscription;

  SearchTransactionBloc(this.transactionRepository, this.categoryRepository) : super(const SearchTransactionState()) {
    on<SearchTransactionQueryChanged>(_onQueryChanged);
    on<SearchTransactionTypeChanged>(_onTypeChanged);
    on<SearchTransactionReset>(_onReset);
    on<SearchTransactionApply>(_onApply);
    on<SearchTransactionUpdateTransaction>(_onUpdateTransaction);
    on<SearchTransactionDeleteTransaction>(_onDeleteTransaction);

    _subscription = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.updateTransaction:
          if (data.payload is Transaction) {
            final tx = data.payload as Transaction;
            add(SearchTransactionUpdateTransaction(tx));
          }
          break;
        case AppEvent.deleteTransaction:
          if (data.payload is int) {
            final id = data.payload as int;
            add(SearchTransactionDeleteTransaction(id));
          }
          break;
        default:
          break;
      }
    });
  }

  void _onQueryChanged(SearchTransactionQueryChanged event, Emitter<SearchTransactionState> emit) {
    emit(state.copyWith(query: event.value));
  }

  void _onTypeChanged(SearchTransactionTypeChanged event, Emitter<SearchTransactionState> emit) {
    if (state.selectedType == event.type) return;
    emit(state.copyWith(selectedType: event.type));
  }

  void _onReset(SearchTransactionReset event, Emitter<SearchTransactionState> emit) {
    emit(state.copyWith(query: '', selectedType: null, results: [], groupedResults: {}, categoriesMap: {}));
  }

  Future<void> _onApply(SearchTransactionApply event, Emitter<SearchTransactionState> emit) async {
    if (state.query.isEmpty) return;

    final searchResult = await _filter(content: state.query, transactionType: state.selectedType);

    searchResult.fold(
      (failure) {
        logger.e('SearchTransactionBloc: error when applying search: ${failure.message}');
        emit(state.copyWith(results: [], groupedResults: {}, categoriesMap: {}));
      },
      (data) async {
        final grouped = transactionRepository.groupByDate(data);
        final categoriesResult = await categoryRepository.getAll();

        categoriesResult.fold(
          (failure) {
            logger.e('SearchTransactionBloc: error getting categories: ${failure.message}');
            emit(state.copyWith(results: data, groupedResults: grouped, categoriesMap: {}));
          },
          (allCategories) {
            final categoriesMap = {for (final cat in allCategories) cat.id!: cat};
            emit(state.copyWith(results: data, groupedResults: grouped, categoriesMap: categoriesMap));
          },
        );
      },
    );
  }

  Future<Either<Failure, List<Transaction>>> _filter({String? content, TransactionType? transactionType}) async {
    final result = await transactionRepository.searchByContent(keyword: content, transactionType: transactionType?.typeIndex);
    return result.map((pagedResult) => pagedResult.transactions);
  }

  void _onUpdateTransaction(SearchTransactionUpdateTransaction event, Emitter<SearchTransactionState> emit) {
    final updatedTransaction = event.transaction;

    // Check if the updated transaction still matches the current search criteria
    final stillMatches = _matchesSearchCriteria(updatedTransaction);

    List<Transaction> updatedResults;

    if (stillMatches) {
      // Transaction still matches → update it
      updatedResults = state.results.map((t) {
        return t.id == updatedTransaction.id ? updatedTransaction : t;
      }).toList();
    } else {
      // Transaction no longer matches → remove it
      updatedResults = state.results.where((t) => t.id != updatedTransaction.id).toList();
    }

    final grouped = transactionRepository.groupByDate(updatedResults);
    emit(state.copyWith(results: updatedResults, groupedResults: grouped));
  }

  bool _matchesSearchCriteria(Transaction transaction) {
    // Check content match
    if (state.query.isNotEmpty) {
      final contentMatch = transaction.content.toLowerCase().contains(state.query.toLowerCase());
      if (!contentMatch) return false;
    }

    // Check type match
    if (state.selectedType != null) {
      if (transaction.transactionType != state.selectedType!.typeIndex) return false;
    }

    return true;
  }

  void _onDeleteTransaction(SearchTransactionDeleteTransaction event, Emitter<SearchTransactionState> emit) {
    final updated = state.results.where((t) => t.id != event.id).toList();
    final grouped = transactionRepository.groupByDate(updated);
    emit(state.copyWith(results: updated, groupedResults: grouped));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
