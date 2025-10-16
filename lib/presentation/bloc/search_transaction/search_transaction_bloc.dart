import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'search_transaction_event.dart';
import 'search_transaction_state.dart';

class SearchTransactionBloc extends Bloc<SearchTransactionEvent, SearchTransactionState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  StreamSubscription<AppStreamData>? _subscription;

  SearchTransactionBloc(this.transactionService, this.categoryService) : super(const SearchTransactionState()) {
    on<SearchTransactionQueryChanged>(_onQueryChanged);
    on<SearchTransactionTypeChanged>(_onTypeChanged);
    on<SearchTransactionReset>(_onReset);
    on<SearchTransactionApply>(_onApply);
    on<SearchTransactionUpdateTransaction>(_onUpdateTransaction);
    on<SearchTransactionDeleteTransaction>(_onDeleteTransaction);

    _subscription = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.updateTransaction:
          final tx = data.payload as Transaction;
          add(SearchTransactionUpdateTransaction(tx));
          break;
        case AppEvent.deleteTransaction:
          final id = data.payload as int;
          add(SearchTransactionDeleteTransaction(id));
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

    try {
      final List<Transaction> data = await _filter(content: state.query, transactionType: state.selectedType);

      final grouped = transactionService.groupByDate(data);
      final allCategories = await categoryService.getAll();
      final categoriesMap = {for (final cat in allCategories) cat.id!: cat};

      emit(state.copyWith(results: data, groupedResults: grouped, categoriesMap: categoriesMap));
    } catch (e) {
      logger.e('SearchTransactionBloc: error when applying search: $e');
      emit(state.copyWith(results: [], groupedResults: {}, categoriesMap: {}));
    }
  }

  Future<List<Transaction>> _filter({String? content, TransactionType? transactionType}) async {
    final PagedTransactionResult transactionsRs = await transactionService.searchByContent(keyword: content, transactionType: transactionType?.typeIndex);
    return transactionsRs.transactions;
  }

  void _onUpdateTransaction(SearchTransactionUpdateTransaction event, Emitter<SearchTransactionState> emit) {
    final updated = state.results.map((t) {
      return t.id == event.transaction.id ? event.transaction : t;
    }).toList();

    final grouped = transactionService.groupByDate(updated);
    emit(state.copyWith(results: updated, groupedResults: grouped));
  }

  void _onDeleteTransaction(SearchTransactionDeleteTransaction event, Emitter<SearchTransactionState> emit) {
    final updated = state.results.where((t) => t.id != event.id).toList();
    final grouped = transactionService.groupByDate(updated);
    emit(state.copyWith(results: updated, groupedResults: grouped));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
