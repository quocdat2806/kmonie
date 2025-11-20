import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/args/args.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';

class AddBudgetPage extends StatelessWidget {
  final AddBudgetArgs? args;
  const AddBudgetPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return AddBudgetPageChild(args: args);
  }
}

class AddBudgetPageChild extends StatefulWidget {
  final AddBudgetArgs? args;
  const AddBudgetPageChild({super.key, this.args});

  @override
  State<AddBudgetPageChild> createState() => _AddBudgetPageChildState();
}

class _AddBudgetPageChildState extends State<AddBudgetPageChild> {
  @override
  void initState() {
    super.initState();
    final a = widget.args;
    context.read<AddBudgetBloc>().add(AddBudgetEventInit(args: a!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: AppTextConstants.settingMonthlyBudget),
      body: SizedBox.expand(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: BlocBuilder<AddBudgetBloc, AddBudgetState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        _buildBudgetItem(
                          title: AppTextConstants.monthlyBudget,
                          currentAmount: state.monthlyBudget > 0
                              ? state.monthlyBudget.toString()
                              : '',
                          onTap: () {
                            context.read<AddBudgetBloc>().add(
                              const AddBudgetEvent.setCurrentInputIdCategory(),
                            );
                          },
                          isMonthlyBudget: true,
                          isSelected:
                              state.currentInputIdCategory == null &&
                              state.isKeyboardVisible,
                        ),
                        Expanded(
                          child: ListView.builder(
                            cacheExtent: 250.0,
                            padding: EdgeInsets.only(
                              bottom: state.isKeyboardVisible ? 280 : 0,
                            ),
                            itemCount: state.expenseCategories.length,
                            itemBuilder: (context, index) {
                              final category = state.expenseCategories[index];
                              final categoryId = category.id ?? 0;
                              final amount =
                                  state.categoryBudgets[categoryId] ?? 0;
                              return _buildBudgetItem(
                                title: category.title,
                                currentAmount: amount > 0
                                    ? amount.toString()
                                    : '',
                                onTap: () {
                                  context.read<AddBudgetBloc>().add(
                                    AddBudgetEvent.setCurrentInputIdCategory(
                                      id: categoryId,
                                    ),
                                  );
                                },
                                category: category,
                                isSelected:
                                    state.currentInputIdCategory ==
                                        categoryId &&
                                    state.isKeyboardVisible,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              BlocSelector<AddBudgetBloc, AddBudgetState, bool>(
                selector: (state) => state.isKeyboardVisible,
                builder: (context, isKeyboardVisible) {
                  if (!isKeyboardVisible) return const SizedBox.shrink();
                  return BlocBuilder<AddBudgetBloc, AddBudgetState>(
                    buildWhen: (prev, curr) =>
                        prev.currentInputIdCategory !=
                            curr.currentInputIdCategory ||
                        prev.currentInput != curr.currentInput,
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.all(
                          AppUIConstants.smallPadding,
                        ),
                        color: AppColorConstants.greyWhite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  FormatUtils.formatCurrency(
                                    state.currentInput,
                                  ),
                                  style: AppTextStyle.blackS20Bold,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppUIConstants.smallSpacing),
                            AppKeyboard(
                              onValueChanged: (value) {
                                context.read<AddBudgetBloc>().add(
                                  AddBudgetEvent.inputKey(key: value),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetItem({
    required String title,
    TransactionCategory? category,
    required String currentAmount,
    required VoidCallback onTap,
    bool isMonthlyBudget = false,
    bool isSelected = false,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColorConstants.greyWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(AppUIConstants.smallBorderRadius),
        ),
        margin: const EdgeInsets.all(AppUIConstants.smallMargin),
        padding: const EdgeInsets.all(AppUIConstants.smallPadding),
        child: Row(
          children: [
            if (!isMonthlyBudget) ...[
              Container(
                width: AppUIConstants.defaultContainerSize,
                height: AppUIConstants.defaultContainerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: GradientHelper.fromColorHexList(
                    category!.gradientColors,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppUIConstants.smallPadding),
                  child: SvgUtils.icon(assetPath: category.pathAsset),
                ),
              ),
              const SizedBox(width: AppUIConstants.smallSpacing),
            ],
            Expanded(child: Text(title, style: AppTextStyle.blackS14Medium)),
            if (currentAmount.isNotEmpty && int.parse(currentAmount) > 0)
              Text(
                FormatUtils.formatCurrency(int.parse(currentAmount)),
                style: AppTextStyle.blackS14Medium,
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColorConstants.grey,
                size: AppUIConstants.smallIconSize,
              ),
          ],
        ),
      ),
    );
  }
}
