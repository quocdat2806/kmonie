import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/export.dart';
import '../../../core/di/export.dart';
import '../../../core/enum/export.dart';
import '../../../core/navigation/export.dart';
import '../../../core/service/export.dart';
import '../../../core/text_style/export.dart';
import '../../../entity/export.dart';
import '../../../generated/export.dart';
import '../../bloc/export.dart';
import '../../widgets/export.dart';

class SearchTransactionPage extends StatelessWidget {
  const SearchTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchTransactionBloc>(create: (_) => SearchTransactionBloc(sl<TransactionService>(), sl<TransactionCategoryService>()), child: const SearchTransactionPageChild());
  }
}

class SearchTransactionPageChild extends StatefulWidget {
  const SearchTransactionPageChild({super.key});

  @override
  State<SearchTransactionPageChild> createState() => _SearchTransactionPageChildState();
}

class _SearchTransactionPageChildState extends State<SearchTransactionPageChild> {
  final TextEditingController _searchController = TextEditingController();
  final categories = <Map<String, dynamic>>[
    {'label': TextConstants.all, 'type': null},
    {'label': TextConstants.income, 'type': TransactionType.income},
    {'label': TextConstants.expense, 'type': TransactionType.expense},
    {'label': TextConstants.transfer, 'type': TransactionType.transfer},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
          color: ColorConstants.white,
          child: Column(children: [_buildSearchHeader(), _buildSearchCategoryButtons(), _buildActionButton(), _buildSearchList()]),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return ColoredBox(
      color: ColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Column(
          spacing: UIConstants.defaultSpacing,
          children: [
            Row(
              children: <Widget>[
                InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: () => AppNavigator(context: context).pop(),
                ),
                Expanded(
                  child: Center(child: Text(TextConstants.search, style: AppTextStyle.blackS18Bold)),
                ),
              ],
            ),
            BlocBuilder<SearchTransactionBloc, SearchTransactionState>(
              buildWhen: (previous, current) => previous.query != current.query,
              builder: (context, state) {
                return AppTextField(
                  controller: _searchController,
                  filledColor: ColorConstants.white,
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(UIConstants.smallPadding),
                    suffixIcon: state.query.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              context.read<SearchTransactionBloc>().add(const SearchTransactionEvent.reset());
                              _searchController.clear();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: UIConstants.smallPadding),
                              child: Icon(Icons.close, size: UIConstants.mediumIconSize),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: UIConstants.smallPadding),
                            child:SvgConstants.icon(assetPath: Assets.svgsSearch, size: SvgSizeType.medium),
                          ),
                    suffixIconConstraints: const BoxConstraints(),
                  ),
                  onChanged: (value) => context.read<SearchTransactionBloc>().add(SearchTransactionEvent.queryChanged(value)),
                  onFieldSubmitted: (value) {
                    context.read<SearchTransactionBloc>().add(const SearchTransactionEvent.apply());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<SearchTransactionBloc, SearchTransactionState>(
          buildWhen: (previous, current) => previous.selectedType != current.selectedType,
          builder: (context, state) {
            return Row(
              spacing: UIConstants.smallSpacing,
              children: [
                Text('Kiểu', style: AppTextStyle.blackS14Bold),
                ...categories.map((item) {
                  final bool isSelected = state.selectedType == item['type'];
                  return AppButton(
                    text: item['label'] as String,
                    backgroundColor: isSelected ? ColorConstants.primary : ColorConstants.grey.withAlpha(50),
                    textColor: isSelected ? ColorConstants.white : ColorConstants.black,
                    onPressed: () {
                      context.read<SearchTransactionBloc>().add(SearchTransactionEvent.typeChanged(item['type'] as TransactionType?));
                    },
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchList() {
    return Expanded(
      child: BlocSelector<SearchTransactionBloc, SearchTransactionState, ({Map<String, List<Transaction>> groupedResults, Map<int, TransactionCategory> categoriesMap})>(
        selector: (state) => (groupedResults: state.groupedResults, categoriesMap: state.categoriesMap),
        builder: (context, data) {
          return TransactionList(emptyWidget: _buildEmptyResult(), groupedTransactions: data.groupedResults, categoriesMap: data.categoriesMap);
        },
      ),
    );
  }

  Widget _buildEmptyResult() {
    return Center(child: Text('Không có kết quả', style: AppTextStyle.blackS14));
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.defaultPadding),
      child: Row(
        spacing: UIConstants.defaultPadding,
        children: [
          Expanded(
            child: AppButton(
              backgroundColor: ColorConstants.greyWhite,
              iconWidget: SvgConstants.icon(assetPath: Assets.svgsReplay, size: SvgSizeType.medium),
              onPressed: () {
                context.read<SearchTransactionBloc>().add(const SearchTransactionEvent.reset());
                _searchController.clear();
              },
            ),
          ),
          Expanded(
            child: AppButton(
              iconWidget:const Icon(Icons.check, size: UIConstants.mediumIconSize),
              onPressed: () {
                context.read<SearchTransactionBloc>().add(const SearchTransactionEvent.apply());
              },
            ),
          ),
        ],
      ),
    );
  }
}
