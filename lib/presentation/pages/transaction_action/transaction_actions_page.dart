import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/args/args.dart';
import 'widgets/transaction_actions_input_header.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

class TransactionActionsPage extends StatelessWidget {
  final TransactionActionsPageArgs? args;

  const TransactionActionsPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return TransactionActionsPageChild(args: args);
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
  late ScrollController _scrollController;
  final GlobalKey _gridKey = GlobalKey();

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
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;

    final view = View.of(context);
    final keyboardHeight = view.viewInsets.bottom / view.devicePixelRatio;
    final currentState = context.read<TransactionActionsBloc>().state;

    if (keyboardHeight == currentState.previousKeyboardHeight) return;

    context.read<TransactionActionsBloc>().add(
      TransactionActionsEvent.updateKeyboardHeight(keyboardHeight),
    );

    if (keyboardHeight > 0) {
      _animationController.forward();
      return;
    }
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return BlocListener<TransactionActionsBloc, TransactionActionsState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success && !state.hasPopped) {
          if (AppNavigator(context: context).canPop()) {
            context.read<TransactionActionsBloc>().add(
              const TransactionActionsEvent.setHasPopped(true),
            );
            AppNavigator(context: context).pop();
          }
        }
        if (state.selectDateState == SelectDateState.showDatePicker) {
          _showDatePicker(context);
          context.read<TransactionActionsBloc>().add(
            const ClearSelectDateState(),
          );
        }

        if (state.overBudgetState == OverBudgetState.showOverBudgetDialog) {
          _showOverBudgetDialog(context);
          context.read<TransactionActionsBloc>().add(
            const ClearOverBudgetState(),
          );
        }

        if (state.isKeyboardVisible &&
            state.shouldScroll &&
            !state.hasScrolledOnce) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients &&
                _gridKey.currentContext != null) {
              final RenderBox gridRenderBox =
                  _gridKey.currentContext!.findRenderObject() as RenderBox;
              final gridHeight = gridRenderBox.size.height;
              final targetPosition = gridHeight / 2;
              _scrollController.animateTo(
                targetPosition,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
              context.read<TransactionActionsBloc>().add(
                const TransactionActionsEvent.setHasScrolledOnce(true),
              );
            }
          });
        }

        if (!state.isKeyboardVisible) {
          context.read<TransactionActionsBloc>().add(
            const TransactionActionsEvent.resetScrollState(),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColorConstants.white,
        body: SizedBox.expand(
          child: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      ColoredBox(
                        color: AppColorConstants.primary,
                        child: Column(
                          children: [
                            _buildAppBar(),
                            const TransactionActionsTabBar(),
                            const SizedBox(
                              height: AppUIConstants.defaultSpacing,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<TransactionActionsBloc, TransactionActionsState>(
                          buildWhen: (prev, curr) =>
                              prev.isKeyboardVisible != curr.isKeyboardVisible,
                          builder: (context, state) {
                            return CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Container(
                                    key: _gridKey,
                                    color: AppColorConstants.white,
                                    padding: const EdgeInsets.all(
                                      AppUIConstants.smallPadding,
                                    ),
                                    child: TransactionCategoryGrid(
                                      onItemClick: () {
                                        context.read<TransactionActionsBloc>().add(
                                          const TransactionActionsEvent.setShouldScroll(
                                            true,
                                          ),
                                        );
                                        if (!state.hasScrolledOnce) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                if (_scrollController
                                                        .hasClients &&
                                                    _gridKey.currentContext !=
                                                        null) {
                                                  final RenderBox
                                                  gridRenderBox =
                                                      _gridKey.currentContext!
                                                              .findRenderObject()
                                                          as RenderBox;
                                                  final gridHeight =
                                                      gridRenderBox.size.height;
                                                  final targetPosition =
                                                      gridHeight / 2;
                                                  _scrollController.animateTo(
                                                    targetPosition,
                                                    duration: const Duration(
                                                      milliseconds: 350,
                                                    ),
                                                    curve: Curves.easeOut,
                                                  );
                                                  context
                                                      .read<
                                                        TransactionActionsBloc
                                                      >()
                                                      .add(
                                                        const TransactionActionsEvent.setHasScrolledOnce(
                                                          true,
                                                        ),
                                                      );
                                                }
                                              });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.only(
                                    bottom: state.isKeyboardVisible ? 420 : 0,
                                  ),
                                ),
                              ],
                            );
                          },
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
                                      onValueChanged: (value) {
                                        final bloc = context
                                            .read<TransactionActionsBloc>();
                                        if (value == 'SELECT_DATE') {
                                          bloc.add(const RequestSelectDate());
                                          return;
                                        }
                                        if (value == 'DONE') {
                                          bloc.add(const CheckOverBudget());
                                          return;
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
        child: InkWell(
          splashColor: Colors.transparent,
          customBorder: const StadiumBorder(),
          onTap: () async {
            if (context
                .read<TransactionActionsBloc>()
                .state
                .isKeyboardVisible) {
              context.read<TransactionActionsBloc>().add(
                const ToggleKeyboardVisibility(),
              );
              await SystemChannels.textInput.invokeMethod('TextInput.hide');
              await Future<void>.delayed(const Duration(milliseconds: 350));
              if (mounted) {
                AppNavigator(context: context).pop();
              }
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
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final bloc = context.read<TransactionActionsBloc>();
    final state = bloc.state;

    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => DatePickerScreen(initialDate: state.date),
    );

    if (picked != null) {
      bloc.add(SelectDateChange(picked));
    }
  }

  Future<void> _showOverBudgetDialog(BuildContext context) async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) =>
          AppExceedBudgetDialog(onConfirm: () => Navigator.of(ctx).pop(true)),
    );

    if (proceed == true && context.mounted) {
      context.read<TransactionActionsBloc>().add(const SubmitTransaction());
    }
  }
}
