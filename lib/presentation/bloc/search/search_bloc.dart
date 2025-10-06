import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../entity/export.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;

  SearchBloc(this.transactionService, this.categoryService) : super(const SearchState()) {
    on<QueryChanged>(_onQueryChanged);
    on<TypeChanged>(_onTypeChanged);
    on<Reset>(_onReset);
    on<Apply>(_onApply);
  }

  void _onQueryChanged(QueryChanged event, Emitter<SearchState> emit) {
    emit(state.copyWith(query: event.value));
  }

  void _onTypeChanged(TypeChanged event, Emitter<SearchState> emit) {
    if (state.selectedType == event.type) return;
    emit(state.copyWith(selectedType: event.type));
  }

  void _onReset(Reset event, Emitter<SearchState> emit) {
    if (state.query.isEmpty) return;
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
}
