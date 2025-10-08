import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/util/export.dart';
import '../../../entity/export.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  StreamSubscription<AppStreamData>? _subscription;

  SearchBloc(this.transactionService, this.categoryService)
      : super(const SearchState()) {
    on<QueryChanged>(_onQueryChanged);
    on<TypeChanged>(_onTypeChanged);
    on<Reset>(_onReset);
    on<Apply>(_onApply);
    on<UpdateTransactionItem>(_onUpdateTransaction);
    on<DeleteTransationItem>(_onDeleteTransaction);

    _subscription = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.updateTransaction:
          final tx = data.payload as Transaction;
          add(UpdateTransactionItem(tx));
          break;
        case AppEvent.deleteTransaction:
          final id = data.payload as int;
          add(DeleteTransationItem(id));
          break;
        default:
          break;
      }
    });
  }

  void _onQueryChanged(QueryChanged event, Emitter<SearchState> emit) {
    emit(state.copyWith(query: event.value));
  }

  void _onTypeChanged(TypeChanged event, Emitter<SearchState> emit) {
    if (state.selectedType == event.type) return;
    emit(state.copyWith(selectedType: event.type));
  }

  void _onReset(Reset event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      query: '',
      selectedType: null,
      results: [],
      groupedResults: {},
      categoriesMap: {},
    ));
  }

  Future<void> _onApply(Apply event, Emitter<SearchState> emit) async {
    if (state.query.isEmpty) return;

    try {
      final List<Transaction> data = await _filter(
        content: state.query,
        transactionType: state.selectedType,
      );

      final grouped = transactionService.groupByDate(data);
      final allCategories = await categoryService.getAll();
      final categoriesMap = {
        for (final cat in allCategories) cat.id!: cat,
      };

      emit(state.copyWith(
        results: data,
        groupedResults: grouped,
        categoriesMap: categoriesMap,
      ));
    } catch (e) {
      logger.e('SearchBloc: error when applying search: $e');
      emit(state.copyWith(results: [], groupedResults: {}, categoriesMap: {}));
    }
  }

  Future<List<Transaction>> _filter({
    String? content,
    TransactionType? transactionType,
  }) async {
    final PagedTransactionResult data = await transactionService.searchByContent(
      keyword: content,
      transactionType: transactionType?.typeIndex,
    );
    return data.transactions;
  }

  /// ✏️ Khi update transaction từ nơi khác
  void _onUpdateTransaction(
      UpdateTransactionItem event, Emitter<SearchState> emit) {
    final updated = state.results.map((t) {
      return t.id == event.transaction.id ? event.transaction : t;
    }).toList();

    final grouped = transactionService.groupByDate(updated);
    emit(state.copyWith(results: updated, groupedResults: grouped));
  }

  /// 🗑 Khi xoá transaction từ nơi khác
  void _onDeleteTransaction(DeleteTransationItem event, Emitter<SearchState> emit) {
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
