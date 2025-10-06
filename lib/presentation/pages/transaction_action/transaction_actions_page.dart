import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/export.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/enum/export.dart';
import '../../../core/navigation/export.dart';
import '../../../core/service/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/text_style/export.dart';
import '../../../entity/export.dart';
import '../../bloc/export.dart';
import '../../widgets/export.dart';
import 'widgets/transaction_actions_input_header.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

enum TransactionActionsMode { add, edit }

class TransactionActionsPageArgs {
  final TransactionActionsMode mode;
  final Transaction? transaction;

  TransactionActionsPageArgs({
    this.mode = TransactionActionsMode.add,
    this.transaction,
  });
}

class TransactionActionsPage extends StatelessWidget {
  final TransactionActionsPageArgs? args;

  const TransactionActionsPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTransactionBloc>(
      create: (_) => AddTransactionBloc(
        sl<TransactionCategoryService>(),
        sl<TransactionService>(),
        args
      ),
      child:  AddTransactionPageChild(
        args: args,
      ),
    );
  }
}

class AddTransactionPageChild extends StatefulWidget {
  final TransactionActionsPageArgs? args;

  const AddTransactionPageChild({super.key,this.args});

  @override
  State<AddTransactionPageChild> createState() =>
      _AddTransactionPageChildState();
}

class _AddTransactionPageChildState extends State<AddTransactionPageChild>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.args?.transaction?.content ??"";
    _animationController = AnimationController(
      duration: UIConstants.shortAnimationDuration,
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
    return BlocListener<AddTransactionBloc, AddTransactionState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          if(widget.args!=null && widget.args!.mode == TransactionActionsMode.edit){
            AppStreamEvent.updateTransactionStatic(widget.args!.transaction!.id!);
            AppNavigator(context: context).pop();
            return;
          }
          AppStreamEvent.insertLatestTransactionIntoListStatic();
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
                      const TransactionTabBar(),
                      const SizedBox(height: UIConstants.defaultPadding),
                      const Expanded(
                        child: ColoredBox(
                          color: ColorConstants.white,
                          child: Padding(
                            padding: EdgeInsets.all(UIConstants.smallPadding),
                            child: TransactionCategoryGrid(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocSelector<AddTransactionBloc, AddTransactionState, bool>(
                  selector: (state) => state.isKeyboardVisible,
                  builder: (context, isKeyboardVisible) {
                    if (!isKeyboardVisible) return const SizedBox.shrink();
                    return AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        final slideOffset =
                            _slideAnimation.value *
                            keyboardHeight *
                            UIConstants.keyboardSlideRatio;
                        return Transform.translate(
                          offset: Offset(0, -slideOffset),
                          child: child,
                        );
                      },
                      child: RepaintBoundary(
                        child: ColoredBox(
                          color: ColorConstants.iconBackground,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              UIConstants.smallPadding,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TransactionActionsInputHeader(
                                  noteController: _noteController,
                                  noteFocusNode: _noteFocusNode,
                                ),
                                AppKeyboard(
                                  onValueChanged: (value) {
                                    context.read<AddTransactionBloc>().add(
                                      AmountChanged(value),
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
      title: TextConstants.add,
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: UIConstants.mediumContainerSize,
          minHeight: UIConstants.mediumContainerSize,
        ),
        child: Ink(
          decoration: const ShapeDecoration(shape: StadiumBorder()),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () => AppNavigator(context: context).pop(),
            child: Center(
              child: Text(
                TextConstants.cancel,
                style: AppTextStyle.blackS14Medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
