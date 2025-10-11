import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/services/budget.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/entity/entity.dart';
import 'package:kmonie/presentation/bloc/bloc.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'widgets/transaction_actions_input_header.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

class TransactionActionsPageArgs {
  final TransactionActionsMode mode;
  final Transaction? transaction;
  final DateTime? selectedDate;

  TransactionActionsPageArgs({
    this.mode = TransactionActionsMode.add,
    this.transaction,
    this.selectedDate,
  });
}

class TransactionActionsPage extends StatelessWidget {
  final TransactionActionsPageArgs? args;

  const TransactionActionsPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionActionsBloc>(
      create: (_) => TransactionActionsBloc(
        sl<TransactionCategoryService>(),
        sl<TransactionService>(),
        args,
      ),
      child: TransactionActionsPageChild(args: args),
    );
  }
}

class TransactionActionsPageChild extends StatefulWidget {
  final TransactionActionsPageArgs? args;

  const TransactionActionsPageChild({super.key, this.args});

  @override
  State<TransactionActionsPageChild> createState() =>
      _TransactionActionsPageChildState();
}

class _TransactionActionsPageChildState
    extends State<TransactionActionsPageChild>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.args?.transaction?.content ?? '';
    _animationController = AnimationController(
      duration: AppUIConstants.shortAnimationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;

    final view = View.of(context);
    final keyboardHeight = view.viewInsets.bottom / view.devicePixelRatio;

    if (keyboardHeight == _previousKeyboardHeight) return;
    _previousKeyboardHeight = keyboardHeight;

    if (keyboardHeight > 0) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return BlocListener<TransactionActionsBloc, TransactionActionsState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          AppNavigator(context: context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColorConstants.primary,
        body: SizedBox.expand(
          child: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      const TransactionActionsTabBar(),
                      const SizedBox(height: AppUIConstants.defaultPadding),
                      const Expanded(
                        child: ColoredBox(
                          color: AppColorConstants.white,
                          child: Padding(
                            padding: EdgeInsets.all(
                              AppUIConstants.smallPadding,
                            ),
                            child: TransactionCategoryGrid(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocSelector<
                  TransactionActionsBloc,
                  TransactionActionsState,
                  bool
                >(
                  selector: (state) => state.isKeyboardVisible,
                  builder: (context, isKeyboardVisible) {
                    if (!isKeyboardVisible) return const SizedBox.shrink();
                    return AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        final slideOffset =
                            _slideAnimation.value *
                            keyboardHeight *
                            AppUIConstants.keyboardSlideRatio;
                        return Transform.translate(
                          offset: Offset(0, -slideOffset),
                          child: child,
                        );
                      },
                      child: RepaintBoundary(
                        child: ColoredBox(
                          color: AppColorConstants.greyWhite,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppUIConstants.smallPadding,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TransactionActionsInputHeader(
                                  noteController: _noteController,
                                  noteFocusNode: _noteFocusNode,
                                ),
                                BlocBuilder<
                                  TransactionActionsBloc,
                                  TransactionActionsState
                                >(
                                  buildWhen: (pre, curr) =>
                                      pre.date != curr.date,
                                  builder: (context, state) {
                                    return AppKeyboard(
                                      selectDate: state.date,
                                      onValueChanged: (value) async {
                                        final bloc = context
                                            .read<TransactionActionsBloc>();
                                        if (value == 'SELECT_DATE') {
                                          final picked =
                                              await showDialog<DateTime>(
                                                context: context,
                                                builder: (context) =>
                                                    DatePickerScreen(
                                                      initialDate: state.date,
                                                    ),
                                              );
                                          if (picked != null) {
                                            bloc.add(SelectDateChange(picked));
                                          }
                                          return;
                                        }
                                        if (value == 'DONE') {
                                          // Budget check before submit with safe fallbacks
                                          final s = bloc.state;
                                          final type = s.currentType;
                                          final int amount = s.amount;
                                          final int? categoryId = s
                                              .selectedCategoryIdFor(type);
                                          final DateTime date =
                                              s.date ?? DateTime.now();

                                          // If not an expense or invalid data, submit immediately
                                          if (type != TransactionType.expense ||
                                              amount <= 0 ||
                                              categoryId == null) {
                                            bloc.add(const SubmitTransaction());
                                            return;
                                          }

                                          try {
                                            final year = date.year;
                                            final month = date.month;
                                            final amount =
                                                await sl<BudgetService>()
                                                    .getBudgetForCategory(
                                                      year: year,
                                                      month: month,
                                                      categoryId: categoryId,
                                                    );
                                            if (amount <= 0) {
                                              bloc.add(
                                                const SubmitTransaction(),
                                              );
                                              return;
                                            }

                                            final range =
                                                AppDateUtils.monthRangeUtc(
                                                  year,
                                                  month,
                                                );
                                            final all =
                                                await sl<TransactionService>()
                                                    .getAllTransactions();
                                            final startLocal = range.startUtc
                                                .toLocal();
                                            final endLocal = range.endUtc
                                                .toLocal();
                                            final spentSoFar = all
                                                .where(
                                                  (t) =>
                                                      t.transactionCategoryId ==
                                                          categoryId &&
                                                      t.transactionType ==
                                                          TransactionType
                                                              .expense
                                                              .typeIndex &&
                                                      !t.date.isBefore(
                                                        startLocal,
                                                      ) &&
                                                      t.date.isBefore(endLocal),
                                                )
                                                .fold<int>(
                                                  0,
                                                  (p, t) => p + t.amount,
                                                );
                                            final proposed =
                                                spentSoFar + amount;
                                            if (proposed > amount) {
                                              final proceed = await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                    'Vượt ngân sách',
                                                  ),
                                                  content: const Text(
                                                    'Khoản này sẽ vượt ngân sách tháng cho danh mục. Tiếp tục?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            ctx,
                                                          ).pop(false),
                                                      child: const Text('Huỷ'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            ctx,
                                                          ).pop(true),
                                                      child: const Text(
                                                        'Tiếp tục',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (proceed == true) {
                                                bloc.add(
                                                  const SubmitTransaction(),
                                                );
                                              }
                                              return;
                                            }

                                            // Under budget -> proceed
                                            bloc.add(const SubmitTransaction());
                                            return;
                                          } catch (_) {
                                            // On any error, do not block submitting
                                            bloc.add(const SubmitTransaction());
                                            return;
                                          }
                                        }
                                        bloc.add(AmountChanged(value));
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      title: AppTextConstants.add,
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppUIConstants.mediumContainerSize,
          minHeight: AppUIConstants.mediumContainerSize,
        ),
        child: Ink(
          decoration: const ShapeDecoration(shape: StadiumBorder()),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () {
              if (context
                  .read<TransactionActionsBloc>()
                  .state
                  .isKeyboardVisible) {
                context.read<TransactionActionsBloc>().add(
                  const ToggleKeyboardVisibility(),
                );
                Future.delayed(const Duration(milliseconds: 850), () {
                  AppNavigator(context: context).pop();
                });
                return;
              }
              AppNavigator(context: context).pop();
            },
            child: Center(
              child: Text(
                AppTextConstants.cancel,
                style: AppTextStyle.blackS14Medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
