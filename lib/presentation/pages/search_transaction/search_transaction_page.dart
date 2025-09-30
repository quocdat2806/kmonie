import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kmonie/lib.dart';
import '../../bloc/search/search_export.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<SearchBloc>().add(
        SearchEvent.queryChanged(_searchController.text),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => SearchBloc(sl<TransactionService>()),
      child: Scaffold(
        body: SafeArea(
          child: ColoredBox(
            color: ColorConstants.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SearchHeader(),
                const _TypeChips(),
                _ActionButtons(onClearQuery: () => _searchController.text = ''),
                const Expanded(child: _ResultList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    return _formatAmountStatic(amount);
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader();

  @override
  Widget build(BuildContext context) {
    final query = context.select((SearchBloc b) => b.state.query);
    return ColoredBox(
      color: ColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Column(
          spacing: 16,
          children: [
            Row(
              children: <Widget>[
                const InkWell(child: Icon(Icons.arrow_back)),
                Expanded(
                  child: Center(
                    child: Text('Tìm kiếm', style: AppTextStyle.blackS18Bold),
                  ),
                ),
              ],
            ),
            AppTextField(
              controller: TextEditingController(text: query),
              filledColor: ColorConstants.white,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
                suffixIcon: Padding(
                  padding: const EdgeInsetsGeometry.only(right: 12),
                  child: SvgCacheManager().getSvg(
                    Assets.svgsSearch,
                    UIConstants.mediumIconSize,
                    UIConstants.mediumIconSize,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(),
              ),
              onChanged: (value) => context.read<SearchBloc>().add(
                SearchEvent.queryChanged(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChips extends StatelessWidget {
  const _TypeChips();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text('Kiểu', style: AppTextStyle.blackS14Bold),
            const SizedBox(width: 8),
            AppButton(
              width: 100,
              text: 'Tất cả',
              borderRadius: 100,
              onPressed: () {
                context.read<SearchBloc>().add(
                  const SearchEvent.typeChanged(null),
                );
              },
            ),
            const SizedBox(width: 8),
            AppButton(
              width: 100,
              text: 'Thu nhập',
              borderRadius: 100,
              onPressed: () {
                context.read<SearchBloc>().add(
                  const SearchEvent.typeChanged(TransactionType.income),
                );
              },
            ),
            const SizedBox(width: 8),
            AppButton(
              width: 100,
              borderRadius: 100,
              text: 'Chi tiêu',
              onPressed: () {
                context.read<SearchBloc>().add(
                  const SearchEvent.typeChanged(TransactionType.expense),
                );
              },
            ),
            const SizedBox(width: 8),
            AppButton(
              width: 140,
              borderRadius: 100,
              text: 'Chuyển khoản',
              onPressed: () {
                context.read<SearchBloc>().add(
                  const SearchEvent.typeChanged(TransactionType.transfer),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onClearQuery;

  const _ActionButtons({required this.onClearQuery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: Row(
        spacing: 32,
        children: [
          Expanded(
            child: AppButton(
              borderRadius: 4,
              backgroundColor: ColorConstants.iconBackground,
              iconWidget: SvgCacheManager().getSvg(
                Assets.svgsReplay,
                UIConstants.mediumIconSize,
                UIConstants.mediumIconSize,
              ),
              onPressed: () {
                context.read<SearchBloc>().add(const SearchEvent.reset());
                onClearQuery();
              },
            ),
          ),
          Expanded(
            child: AppButton(
              borderRadius: 4,
              iconWidget: SvgCacheManager().getSvg(
                Assets.svgsCheck,
                UIConstants.mediumIconSize,
                UIConstants.mediumIconSize,
              ),
              onPressed: () {
                context.read<SearchBloc>().add(const SearchEvent.apply());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SearchBloc,
      SearchState,
      ({bool isLoading, List<Transaction> results})
    >(
      selector: (state) => (isLoading: state.isLoading, results: state.results),
      builder: (context, data) {
        if (data.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (data.results.isEmpty) {
          return Center(
            child: Text(
              'Không có giao dịch phù hợp',
              style: AppTextStyle.greyS14,
            ),
          );
        }
        return ListView.separated(
          itemCount: data.results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final t = data.results[index];
            return ListTile(
              title: Text(t.content, style: AppTextStyle.blackS14Bold),
              subtitle: Text(
                DateFormat('dd/MM/yyyy').format(t.date),
                style: AppTextStyle.greyS12,
              ),
              trailing: Text(
                _formatAmountStatic(t.amount),
                style: AppTextStyle.blackS14Bold,
              ),
            );
          },
        );
      },
    );
  }
}

String _formatAmountStatic(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: 0,
  );
  return '${formatter.format(amount)}đ';
}
