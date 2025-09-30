import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/service/exports.dart';
import '../../../entity/exports.dart';
import '../../../core/util/debounce.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TransactionService transactionService;

  SearchBloc(this.transactionService) : super(const SearchState()) {
    on<SearchInitialized>(_onInit);
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: restartableDebounce(const Duration(milliseconds: 250)),
    );
    on<SearchTypeChanged>(_onTypeChanged);
    on<SearchReset>(_onReset);
    on<SearchApply>(_onApply);
    add(const SearchEvent.initialized());
  }

  Future<void> _onInit(
    SearchInitialized event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final allTx = await transactionService.getAllTransactions();
    emit(state.copyWith(all: allTx, isLoading: false, results: allTx));
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    final next = state.copyWith(query: event.query);
    emit(next.copyWith(results: _filter(next)));
  }

  void _onTypeChanged(SearchTypeChanged event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        selectedType: event.type,
        results: _filter(state.copyWith(selectedType: event.type)),
      ),
    );
  }

  void _onReset(SearchReset event, Emitter<SearchState> emit) {
    emit(state.copyWith(query: '', selectedType: null, results: state.all));
  }

  void _onApply(SearchApply event, Emitter<SearchState> emit) {
    emit(state.copyWith(results: _filter(state)));
  }

  List<Transaction> _filter(SearchState s) {
    final lower = s.query.trim().toLowerCase();
    return s.all.where((t) {
      final matchesQuery = lower.isEmpty
          ? true
          : t.content.toLowerCase().contains(lower);
      final matchesType = s.selectedType == null
          ? true
          : t.transactionType == s.selectedType!.typeIndex;
      return matchesQuery && matchesType;
    }).toList();
  }
}
