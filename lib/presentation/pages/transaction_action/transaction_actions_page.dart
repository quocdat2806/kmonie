import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/export.dart';
import '../../../core/di/export.dart';
import '../../../core/enum/export.dart';
import '../../../core/navigation/export.dart';
import '../../../core/service/export.dart';
import '../../../core/text_style/export.dart';
import '../../../entity/export.dart';
import '../../bloc/export.dart';
import '../../widgets/export.dart';
import 'widgets/transaction_actions_input_header.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

class TransactionActionsPageArgs {
  final TransactionActionsMode mode;
  final Transaction? transaction;

  TransactionActionsPageArgs({this.mode = TransactionActionsMode.add, this.transaction});
}

class TransactionActionsPage extends StatelessWidget {
  final TransactionActionsPageArgs? args;

  const TransactionActionsPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionActionsBloc>(
      create: (_) => TransactionActionsBloc(sl<TransactionCategoryService>(), sl<TransactionService>(), args),
      child: TransactionActionsPageChild(args: args),
    );
  }
}

class TransactionActionsPageChild extends StatefulWidget {
  final TransactionActionsPageArgs? args;

  const TransactionActionsPageChild({super.key, this.args});

  @override
  State<TransactionActionsPageChild> createState() => _TransactionActionsPageChildState();
}

class _TransactionActionsPageChildState extends State<TransactionActionsPageChild> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.args?.transaction?.content ?? "";
    _animationController = AnimationController(duration: UIConstants.shortAnimationDuration, vsync: this);
    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart));
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
        backgroundColor: ColorConstants.primary,
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
                      const SizedBox(height: UIConstants.defaultPadding),
                      const Expanded(
                        child: ColoredBox(
                          color: ColorConstants.white,
                          child: Padding(padding: EdgeInsets.all(UIConstants.smallPadding), child: TransactionCategoryGrid()),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocSelector<TransactionActionsBloc, TransactionActionsState, bool>(
                  selector: (state) => state.isKeyboardVisible,
                  builder: (context, isKeyboardVisible) {
                    if (!isKeyboardVisible) return const SizedBox.shrink();
                    return AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        final slideOffset = _slideAnimation.value * keyboardHeight * UIConstants.keyboardSlideRatio;
                        return Transform.translate(offset: Offset(0, -slideOffset), child: child);
                      },
                      child: RepaintBoundary(
                        child: ColoredBox(
                          color: ColorConstants.greyWhite,
                          child: Padding(
                            padding: const EdgeInsets.all(UIConstants.smallPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TransactionActionsInputHeader(noteController: _noteController, noteFocusNode: _noteFocusNode),
                                AppKeyboard(
                                  onValueChanged: (value) {
                                    final bloc = context.read<TransactionActionsBloc>();
                                    if (value == 'DONE') {
                                      bloc.add(const SubmitTransaction());
                                    } else {
                                      bloc.add(AmountChanged(value));
                                    }
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
      title: TextConstants.add,
      leading: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: UIConstants.mediumContainerSize, minHeight: UIConstants.mediumContainerSize),
        child: Ink(
          decoration: const ShapeDecoration(shape: StadiumBorder()),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () {
              if(context.read<TransactionActionsBloc>().state.isKeyboardVisible){
                context.read<TransactionActionsBloc>().add(const ToggleKeyboardVisibility());
                Future.delayed(const Duration(milliseconds: 850), () {
                  AppNavigator(context: context).pop();
                });
                return;
              }
              AppNavigator(context: context).pop();


            },
            child: Center(child: Text(TextConstants.cancel, style: AppTextStyle.blackS14Medium)),
          ),
        ),
      ),
    );
  }
}
