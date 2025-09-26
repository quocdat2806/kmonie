import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/lib.dart';
import 'package:kmonie/presentation/widgets/keyboard/app_keyboard.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTransactionBloc>(
      create: (_) => AddTransactionBloc(),
      child: const AddTransactionPageChild(),
    );
  }
}

class AddTransactionPageChild extends StatefulWidget {
  const AddTransactionPageChild({super.key});

  @override
  State<AddTransactionPageChild> createState() => _AddTransactionPageChildState();
}

class _AddTransactionPageChildState extends State<AddTransactionPageChild>
    with SingleTickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isSystemKeyboardVisible = keyboardHeight > 0;

    // Trigger animation when system keyboard visibility changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isSystemKeyboardVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.yellow,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  title: 'Thêm',
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Text('Hủy', style: AppTextStyle.blackS14Medium),
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {},
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.divider,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            UIConstants.smallPadding,
                          ),
                          child: SvgPicture.asset(Assets.svgsChecklist),
                        ),
                      ),
                    ),
                    const SizedBox(width: UIConstants.defaultPadding),
                  ],
                ),
                const TransactionTabBar(),
                const SizedBox(height: UIConstants.defaultPadding),
                // const Expanded(
                //   child: ColoredBox(
                //     color: ColorConstants.white,
                //     child: Padding(
                //       padding: EdgeInsets.all(UIConstants.smallPadding),
                //       child: TransactionCategoryGrid(),
                //     ),
                //   ),
                // ),
              ],
            ),

            // Custom Keyboard Overlay
            BlocBuilder<AddTransactionBloc, AddTransactionState>(
              builder: (context, state) {
                if (state.isKeyboardVisible != true) {
                  return const SizedBox();
                }

                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      final slideOffset = _slideAnimation.value * keyboardHeight * 0.3;
                      return Transform.translate(
                        offset: Offset(0, -slideOffset),
                        child: Material(
                          elevation: 8,
                          child: Container(
                            color: ColorConstants.grey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header với số tiền
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  color: ColorConstants.grey,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          context.read<AddTransactionBloc>().add(
                                            const AddTransactionToggleKeyboardVisibility(),
                                          );
                                          _noteFocusNode.unfocus();
                                        },
                                        child: const Icon(Icons.keyboard_hide),
                                      ),
                                      Text("0", style: AppTextStyle.blackS20Bold),
                                      const SizedBox(width: 24),
                                    ],
                                  ),
                                ),

                                // Note input section
                                Container(
                                  color: ColorConstants.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Ghi chú: ', style: AppTextStyle.greyS14),
                                      Expanded(
                                        child: AppTextField(
                                          border: InputBorder.none,
                                          borderBottomColor: Colors.transparent,
                                          controller: _noteController,
                                          focusNode: _noteFocusNode,
                                          hintText: "Ghi chu",
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle camera action
                                        },
                                        child: const Icon(Icons.camera_alt),
                                      ),
                                    ],
                                  ),
                                ),

                                // Custom keyboard - System keyboard sẽ đè lên phần này
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: isSystemKeyboardVisible ? 0.3 : 1.0,
                                  child: CustomKeyboard(
                                    onValueChanged: (value) {
                                      print('Value changed: $value');
                                    },
                                    onConfirm: () {
                                      _noteFocusNode.unfocus();
                                      context.read<AddTransactionBloc>().add(
                                        const AddTransactionToggleKeyboardVisibility(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}