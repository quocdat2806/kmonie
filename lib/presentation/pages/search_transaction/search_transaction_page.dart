import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class SearchTransactionPage extends StatelessWidget {
  const SearchTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchTransactionPageChild();
  }
}

class SearchTransactionPageChild extends StatefulWidget {
  const SearchTransactionPageChild({super.key});

  @override
  State<SearchTransactionPageChild> createState() => _SearchTransactionPageChildState();
}

class _SearchTransactionPageChildState extends State<SearchTransactionPageChild> {
  final TextEditingController _searchController = TextEditingController();
  final searchCategories = <Map<String, dynamic>>[
    {'label': AppTextConstants.all, 'type': null},
    {'label': AppTextConstants.income, 'type': TransactionType.income},
    {'label': AppTextConstants.expense, 'type': TransactionType.expense},
    {'label': AppTextConstants.transfer, 'type': TransactionType.transfer},
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
          color: AppColorConstants.white,
          child: Column(children: [_buildSearchHeader(), _buildSearchCategoryButtons(), _buildActionButton(), _buildSearchList()]),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return ColoredBox(
      color: AppColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          spacing: AppUIConstants.defaultSpacing,
          children: [
            Row(
              children: <Widget>[
                InkWell(
                  splashColor: Colors.transparent,

                  child: const Icon(Icons.arrow_back),
                  onTap: () => AppNavigator(context: context).pop(),
                ),
                Expanded(
                  child: Center(child: Text(AppTextConstants.search, style: AppTextStyle.blackS18Bold)),
                ),
              ],
            ),
            BlocBuilder<SearchTransactionBloc, SearchTransactionState>(
              buildWhen: (previous, current) => previous.query != current.query,
              builder: (context, state) {
                return AppTextField(
                  controller: _searchController,
                  filledColor: AppColorConstants.white,
                  suffixIcon: state.query.isNotEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(right: AppUIConstants.smallPadding),
                          child: Icon(Icons.clear, size: AppUIConstants.mediumIconSize),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: AppUIConstants.smallPadding),
                          child: SvgUtils.icon(assetPath: Assets.svgsSearch, size: SvgSizeType.medium),
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
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      child: BlocBuilder<SearchTransactionBloc, SearchTransactionState>(
        buildWhen: (previous, current) => previous.selectedType != current.selectedType,
        builder: (context, state) {
          return Row(
            spacing: AppUIConstants.smallSpacing,
            children: [
              Text(AppTextConstants.type, style: AppTextStyle.blackS14Bold),
              Expanded(
                child: SizedBox(
                  height: AppUIConstants.defaultButtonHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.smallPadding),
                    itemCount: searchCategories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppUIConstants.smallSpacing),
                    itemBuilder: (context, index) {
                      final item = searchCategories[index];
                      final bool isSelected = state.selectedType == item['type'];
                      return AppButton(
                        text: item['label'] as String,
                        backgroundColor: isSelected ? AppColorConstants.primary : AppColorConstants.grey.withAlpha(50),
                        textColor: isSelected ? AppColorConstants.white : AppColorConstants.black,
                        onPressed: () {
                          context.read<SearchTransactionBloc>().add(SearchTransactionEvent.typeChanged(item['type'] as TransactionType?));
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
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
    return Center(child: Text(AppTextConstants.noResultsFound, style: AppTextStyle.blackS14));
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding),
      child: Row(
        spacing: AppUIConstants.defaultPadding,
        children: [
          Expanded(
            child: AppButton(
              backgroundColor: AppColorConstants.greyWhite,
              iconWidget: SvgUtils.icon(assetPath: Assets.svgsReplay, size: SvgSizeType.medium),
              onPressed: () {
                context.read<SearchTransactionBloc>().add(const SearchTransactionEvent.reset());
                _searchController.clear();
              },
            ),
          ),
          Expanded(
            child: AppButton(
              iconWidget: const Icon(Icons.check, size: AppUIConstants.mediumIconSize),
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
