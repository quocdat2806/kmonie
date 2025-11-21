import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'widgets/day_selector_widget.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/tools/gradient.dart';

class ReminderTransactionAutomationPage extends StatefulWidget {
  const ReminderTransactionAutomationPage({super.key});

  @override
  State<ReminderTransactionAutomationPage> createState() =>
      _ReminderTransactionAutomationPageState();
}

class _ReminderTransactionAutomationPageState
    extends State<ReminderTransactionAutomationPage> {
  TimeOfDay? _selectedTime;
  final Set<int> _selectedDays = {};
  DateTime? _selectedDate;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedType = AppTextConstants.income;
  List<TransactionCategory> _incomeCategories = [];
  List<TransactionCategory> _expenseCategories = [];
  TransactionCategory? _selectedTransactionCategory;
  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    _selectedTime = now;
    _selectedDate = DateTime.now();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final income = await sl<TransactionCategoryService>().getByType(
      TransactionType.income,
    );
    final expense = await sl<TransactionCategoryService>().getByType(
      TransactionType.expense,
    );
    if (mounted) {
      setState(() {
        _incomeCategories = income;
        _expenseCategories = expense;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onTimeChanged(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
        return;
      }
      _selectedDays.add(day);
    });
  }

  String _getDateDisplayText() {
    if (_selectedDays.isEmpty) {
      final date = _selectedDate ?? DateTime.now();
      return AppDateUtils.formatDate(date);
    }

    if (_selectedDays.length == 7) {
      return AppTextConstants.everyDay;
    }

    const weekdayNames = AppDateUtils.weekdays;
    final dayMapping = {
      0: weekdayNames[0],
      2: weekdayNames[1],
      3: weekdayNames[2],
      4: weekdayNames[3],
      5: weekdayNames[4],
      6: weekdayNames[5],
      7: weekdayNames[6],
    };

    final sortedDays = _selectedDays.toList()
      ..sort((a, b) {
        final order = [2, 3, 4, 5, 6, 7, 0];
        return order.indexOf(a).compareTo(order.indexOf(b));
      });

    final dayNames = sortedDays
        .map((day) => dayMapping[day] ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    if (dayNames.length == 1) {
      return '${AppTextConstants.every} ${dayNames[0]}';
    }

    return '${AppTextConstants.every} ${dayNames.join(', ')}';
  }

  Future<void> _save() async {
    if (_selectedTransactionCategory == null) {
      return;
    }

    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      return;
    }

    final amount = int.tryParse(amountText.replaceAll(RegExp(r'[^\d]'), ''));
    if (amount == null || amount <= 0) {
      return;
    }

    if (_selectedDays.isEmpty && _selectedDate == null) {
      return;
    }

    final dayMapping = {1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 0};
    final selectedDaysToSave = _selectedDays.isEmpty
        ? {dayMapping[(_selectedDate ?? DateTime.now()).weekday] ?? 2}
        : _selectedDays;
    final timeToSave = _selectedTime ?? TimeOfDay.now();
    final transactionType = _selectedType == AppTextConstants.income
        ? TransactionType.income.typeIndex
        : TransactionType.expense.typeIndex;

    try {
      await sl<TransactionAutomationService>().createAutomation(
        amount: amount,
        hour: timeToSave.hour,
        minute: timeToSave.minute,
        selectedDays: selectedDaysToSave,
        transactionCategoryId: _selectedTransactionCategory!.id!,
        content: _notesController.text.trim(),
        transactionType: transactionType,
      );

      if (mounted) {
        AppNavigator(context: context).pop();
      }
    } catch (e) {
      logger.e('Error saving transaction automation: $e');
    }
  }

  void _exit() {
    AppNavigator(context: context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: AppTextConstants.autoSchedule),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TimePickerWidget(
                selectedTime: _selectedTime,
                onTimeChanged: _onTimeChanged,
              ),
              _buildContentSection(),
              Padding(
                padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTextConstants.transactionType,
                      style: AppTextStyle.blackS14Medium,
                    ),
                    const SizedBox(height: AppUIConstants.defaultSpacing),

                    Row(
                      spacing: AppUIConstants.defaultSpacing,
                      children: [
                        AppButton(
                          backgroundColor:
                              _selectedType == AppTextConstants.income
                              ? AppColorConstants.primary
                              : AppColorConstants.grey.withAlpha(50),
                          width: 120,
                          text: AppTextConstants.income,
                          onPressed: () {
                            setState(() {
                              _selectedType = AppTextConstants.income;
                            });
                          },
                        ),
                        AppButton(
                          backgroundColor:
                              _selectedType == AppTextConstants.expense
                              ? AppColorConstants.primary
                              : AppColorConstants.grey.withAlpha(50),
                          width: 120,
                          text: AppTextConstants.expense,
                          onPressed: () {
                            setState(() {
                              _selectedType = AppTextConstants.expense;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppUIConstants.largeSpacing),
                    Row(
                      children: [
                        InkWell(
                          onTap: _showTransactionCategoryPicker,
                          child: Text(
                            AppTextConstants.selectCategory,
                            style: AppTextStyle.blackS14Medium,
                          ),
                        ),
                        const SizedBox(width: AppUIConstants.smallSpacing),
                        if (_selectedTransactionCategory != null) ...[
                          SvgUtils.icon(
                            assetPath: Assets.svgsArrowDown,
                            size: SvgSizeType.medium,
                          ),
                          const SizedBox(width: AppUIConstants.smallSpacing),
                          Text(
                            '${_selectedTransactionCategory!.title} : ',
                            style: AppTextStyle.blackS14Bold,
                          ),
                          const SizedBox(width: AppUIConstants.smallSpacing),
                          Container(
                            width: AppUIConstants.defaultContainerSize,
                            height: AppUIConstants.defaultContainerSize,
                            padding: const EdgeInsets.all(
                              AppUIConstants.smallPadding,
                            ),
                            decoration: BoxDecoration(
                              gradient: GradientHelper.fromColorHexList(
                                _selectedTransactionCategory!.gradientColors,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: SvgUtils.icon(
                              assetPath:
                                  _selectedTransactionCategory!.pathAsset,
                              size: SvgSizeType.medium,
                            ),
                          ),
                        ] else
                          SvgUtils.icon(
                            assetPath: Assets.svgsArrowDown,
                            size: SvgSizeType.medium,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppUIConstants.defaultSpacing),
                    _buildInputField(
                      label: AppTextConstants.notes,
                      child: AppTextField(
                        controller: _notesController,
                        hintText: AppTextConstants.noteHint,
                        filledColor: AppColorConstants.greyWhite,
                      ),
                    ),
                    const SizedBox(height: AppUIConstants.defaultSpacing),
                    _buildInputField(
                      label: AppTextConstants.amount,
                      child: AppTextField(
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        hintText: AppTextConstants.amountHint,
                        filledColor: AppColorConstants.greyWhite,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  void _clearFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _showTransactionCategoryPicker() {
    _clearFocus();
    final categories = _selectedType == AppTextConstants.income
        ? _incomeCategories
        : _expenseCategories;

    if (categories.isEmpty) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColorConstants.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppUIConstants.defaultBorderRadius),
        ),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppTextConstants.selectCategory,
              style: AppTextStyle.blackS16Bold,
            ),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth =
                      constraints.maxWidth /
                      AppUIConstants.defaultGridCrossAxisCount;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              AppUIConstants.defaultGridCrossAxisCount,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return TransactionCategoryItem(
                        category: category,
                        isSelected:
                            _selectedTransactionCategory?.id == category.id,
                        itemWidth: itemWidth,
                        onTap: () {
                          setState(() {
                            _selectedTransactionCategory = category;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppUIConstants.smallSpacing,
      children: [
        Text(label, style: AppTextStyle.blackS14Medium),
        child,
      ],
    );
  }

  Widget _buildContentSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(),
          const SizedBox(height: AppUIConstants.defaultSpacing),
          DaySelectorWidget(
            selectedDays: _selectedDays,
            onDayToggled: _toggleDay,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getDateDisplayText(), style: AppTextStyle.blackS14Medium),
              ],
            ),
          ),
          SvgUtils.icon(
            assetPath: Assets.svgsCalendar,
            size: SvgSizeType.medium,
            color: AppColorConstants.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      child: Row(
        spacing: AppUIConstants.defaultSpacing,
        children: [
          Expanded(
            child: AppButton(
              text: AppTextConstants.exit,
              backgroundColor: Colors.transparent,
              onPressed: _exit,
            ),
          ),
          Expanded(
            child: AppButton(text: AppTextConstants.save, onPressed: _save),
          ),
        ],
      ),
    );
  }
}
