import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/di/exports.dart';
import '../../../core/service/exports.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/exports.dart';

import '../../../core/tool/export.dart';
import '../../../generated/assets.dart';
import '../../bloc/exports.dart';
import '../../widgets/exports.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTransactionBloc>(create: (_) => AddTransactionBloc(sl<TransactionCategoryService>()), child: const AddTransactionPageChild());
  }
}

class AddTransactionPageChild extends StatefulWidget {
  const AddTransactionPageChild({super.key});

  @override
  State<AddTransactionPageChild> createState() => _AddTransactionPageChildState();
}

class _AddTransactionPageChildState extends State<AddTransactionPageChild> with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart));
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final view = View.of(context);
        final keyboardHeight = view.viewInsets.bottom / view.devicePixelRatio;
        if (keyboardHeight != _previousKeyboardHeight) {
          _previousKeyboardHeight = keyboardHeight;
          if (keyboardHeight > 0) {
            _animationController.forward();
            return;
          }
            _animationController.reverse();
        }
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    print("zzzz");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  title: 'Thêm',
                  leading: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: UIConstants.mediumContainerSize, minHeight: UIConstants.mediumContainerSize),
                    child: Ink(
                      decoration: const ShapeDecoration(shape: StadiumBorder()),
                      child: InkWell(
                        customBorder: const StadiumBorder(),
                        onTap: () => Navigator.pop(context),
                        child: Center(child: Text('Hủy', style: AppTextStyle.blackS14Medium)),
                      ),
                    ),
                  ),
                  actions: [
                    Ink(
                      decoration: const ShapeDecoration(color: ColorConstants.iconBackground, shape: CircleBorder()),
                      child: InkWell(
                        onTap: () {},
                        customBorder: const CircleBorder(),
                        child: Padding(padding: const EdgeInsets.all(UIConstants.smallPadding), child: SvgPicture.asset(Assets.svgsChecklist)),
                      ),
                    ),
                    const SizedBox(width: UIConstants.defaultPadding),
                  ],
                ),
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
                      final slideOffset = _slideAnimation.value * keyboardHeight * UIConstants.keyboardSlideRatio;
                      return Transform.translate(
                        offset: Offset(0, -slideOffset),
                        child: ColoredBox(
                          color: ColorConstants.iconBackground,
                          child: Padding(
                            padding: const EdgeInsets.all(UIConstants.smallPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(Assets.svgsCccd, width: UIConstants.largeIconSize, height: UIConstants.largeIconSize),
                                    Text('0', style: AppTextStyle.blackS20Bold),
                                  ],
                                ),
                                const SizedBox(height: UIConstants.smallPadding),
                                Container(
                                  decoration: BoxDecoration(color: ColorConstants.white, borderRadius: BorderRadius.circular(4)),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text('Ghi chú: ', style: AppTextStyle.greyS14),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _noteController,
                                          focusNode: _noteFocusNode,
                                          decoration: const InputDecoration(isDense: true, border: InputBorder.none, fillColor: Colors.transparent, filled: true, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, disabledBorder: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 10)),
                                        ),
                                      ),
                                      InkWell(onTap: () {}, child: const Icon(Icons.camera_alt)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: UIConstants.smallPadding),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 150),
                                  opacity: 1.0,
                                  child: AppKeyboard(
                                    onValueChanged: (value) {},
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
