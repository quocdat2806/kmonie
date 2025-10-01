import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cache/export.dart';
import '../../../core/constant/exports.dart';
import '../../../core/di/export.dart';
import '../../../core/enum/exports.dart';
import '../../../core/navigation/exports.dart';
import '../../../core/service/exports.dart';
import '../../../core/text_style/export.dart';
import '../../../generated/assets.dart';
import '../../bloc/exports.dart';
import '../../widgets/exports.dart';

class SearchTransactionPage extends StatelessWidget {
  const SearchTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(create: (_) => SearchBloc(sl<TransactionService>()), child: const SearchTransactionPageChild());
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
    {'label': TextConstants.incomeTabText, 'type': TransactionType.income},
    {'label': TextConstants.expenseTabText, 'type': TransactionType.expense},
    {'label': TextConstants.transferTabText, 'type': TransactionType.transfer},
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
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) => previous.query != current.query,
      builder: (context, state) {
        return ColoredBox(
          color: ColorConstants.primary,
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.defaultPadding),
            child: Column(
              spacing: UIConstants.defaultPadding,
              children: [
                Row(
                  children: <Widget>[
                    InkWell(
                      child: const Icon(Icons.arrow_back),
                      onTap: () {
                        AppNavigator(context: context).maybePop();
                      },
                    ),
                    Expanded(
                      child: Center(child: Text('Tìm kiếm', style: AppTextStyle.blackS18Bold)),
                    ),
                  ],
                ),
                AppTextField(
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
                              context.read<SearchBloc>().add(const SearchEvent.reset());
                              _searchController.clear();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: UIConstants.smallPadding),
                              child: Icon(Icons.close, size: UIConstants.mediumIconSize),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: UIConstants.smallPadding),
                            child: SvgCacheManager().getSvg(Assets.svgsSearch, UIConstants.mediumIconSize, UIConstants.mediumIconSize),
                          ),
                    suffixIconConstraints: const BoxConstraints(),
                  ),
                  onChanged: (value) => context.read<SearchBloc>().add(SearchEvent.queryChanged(value)),
                  onFieldSubmitted: (value) {
                    context.read<SearchBloc>().add(const SearchEvent.apply());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<SearchBloc, SearchState>(
          buildWhen: (previous, current) => previous.selectedType != current.selectedType,
          builder: (context, state) {
            return Row(
              children: [
                Text('Kiểu', style: AppTextStyle.blackS14Bold),
                const SizedBox(width: UIConstants.smallPadding),
                ...categories.map((item) {
                  final bool isSelected = state.selectedType == item['type'];
                  return Padding(
                    padding: const EdgeInsets.only(right: UIConstants.smallPadding),
                    child: AppButton(
                      text: item['label'] as String,
                      backgroundColor: isSelected ? ColorConstants.primary : Colors.grey.shade300,
                      textColor: isSelected ? ColorConstants.white : ColorConstants.black,
                      onPressed: () {
                        context.read<SearchBloc>().add(SearchEvent.typeChanged(item['type']));
                      },
                    ),
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
      child: BlocBuilder<SearchBloc, SearchState>(
        buildWhen: (previous, current) => previous.results != current.results,
        builder: (context, state) {
          if (state.results.isEmpty) {
            return Center(child: Text('Không có kết quả', style: AppTextStyle.blackS14));
          }
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final item = state.results[index];
              return ListTile(title: Text(item.content), subtitle: Text(item.amount.toString()));
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: Row(
        spacing: UIConstants.largePadding,
        children: [
          Expanded(
            child: AppButton(
              backgroundColor: ColorConstants.iconBackground,
              iconWidget: SvgCacheManager().getSvg(Assets.svgsReplay, UIConstants.mediumIconSize, UIConstants.mediumIconSize),
              onPressed: () {
                context.read<SearchBloc>().add(const SearchEvent.reset());
                _searchController.clear();
              },
            ),
          ),
          Expanded(
            child: AppButton(
              iconWidget: SvgCacheManager().getSvg(Assets.svgsCheck, UIConstants.mediumIconSize, UIConstants.mediumIconSize),
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
