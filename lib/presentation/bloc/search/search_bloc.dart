import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../entity/export.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TransactionService transactionService;

  SearchBloc(this.transactionService) : super(const SearchState()) {
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
    emit(state.copyWith(query: '', selectedType: null, results: []));
  }

  void _onApply(Apply event, Emitter<SearchState> emit) async {
    if (state.query.isEmpty) return;
    final List<Transaction> data = await _filter(content: state.query, transactionType: state.selectedType);
    emit(state.copyWith(results: data));
  }

  Future<List<Transaction>> _filter({String? content, TransactionType? transactionType}) async {
    final PagedTransactionResult data = await transactionService.searchByContent(keyword: content, transactionType: transactionType?.typeIndex ?? null);
    return data.transactions;
  }
}
