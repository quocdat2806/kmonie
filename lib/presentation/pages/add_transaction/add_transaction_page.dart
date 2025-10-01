import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/exports.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/enum/exports.dart';
import '../../../core/navigation/exports.dart';
import '../../../core/service/exports.dart';
import '../../../core/stream/export.dart';
import '../../../core/text_style/export.dart';
import '../../../core/tool/exports.dart';
import '../../bloc/exports.dart';
import '../../widgets/exports.dart';
import 'widgets/add_transaction_input_header.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTransactionBloc>(create: (_) => AddTransactionBloc(sl<TransactionCategoryService>(), sl<TransactionService>()), child: const AddTransactionPageChild());
  }
}

class AddTransactionPageChild extends StatefulWidget {
  const AddTransactionPageChild({super.key});

  @override
  State<AddTransactionPageChild> createState() => _AddTransactionPageChildState();
}

class _AddTransactionPageChildState extends State<AddTransactionPageChild> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
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
    return BlocListener<AddTransactionBloc, AddTransactionState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          AppStreamEvent.refreshHomeDataStatic();
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
                          child: Padding(padding: EdgeInsets.all(UIConstants.smallPadding), child: TransactionCategoryGrid()),
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
                        final slideOffset = _slideAnimation.value * keyboardHeight * UIConstants.keyboardSlideRatio;
                        return Transform.translate(offset: Offset(0, -slideOffset), child: child);
                      },
                      child: RepaintBoundary(
                        child: ColoredBox(
                          color: ColorConstants.iconBackground,
                          child: Padding(
                            padding: const EdgeInsets.all(UIConstants.smallPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AddTransactionInputHeader(noteController: _noteController, noteFocusNode: _noteFocusNode),
                                AppKeyboard(
                                  onValueChanged: (value) {
                                    context.read<AddTransactionBloc>().add(AmountChanged(value));
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
      title: TextConstants.addTransactionTitle,
      leading: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: UIConstants.mediumContainerSize, minHeight: UIConstants.mediumContainerSize),
        child: Ink(
          decoration: const ShapeDecoration(shape: StadiumBorder()),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () => AppNavigator(context: context).pop(),
            child: Center(child: Text(TextConstants.cancelButtonText, style: AppTextStyle.blackS14Medium)),
          ),
        ),
      ),
    );
  }
}
