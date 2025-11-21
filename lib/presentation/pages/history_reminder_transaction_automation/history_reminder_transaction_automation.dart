import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryReminderTransactionAutomation extends StatefulWidget {
  const HistoryReminderTransactionAutomation({super.key});

  @override
  State<HistoryReminderTransactionAutomation> createState() =>
      _HistoryReminderTransactionAutomationState();
}

class _HistoryReminderTransactionAutomationState
    extends State<HistoryReminderTransactionAutomation> {
  List<TransactionAutomationGroup> _automations = [];
  Map<int, TransactionCategory> _categoriesMap = {};

  @override
  void initState() {
    super.initState();
    _loadAutomations();
  }

  Future<void> _loadAutomations() async {
    try {
      final automations = await sl<TransactionAutomationService>()
          .getAllAutomations();
      final allCategories = await sl<TransactionCategoryService>().getAll(
        forceRefresh: false,
      );

      final categoriesMap = <int, TransactionCategory>{};
      for (final category in allCategories) {
        if (category.id != null) {
          categoriesMap[category.id!] = category;
        }
      }

      if (mounted) {
        setState(() {
          _automations = automations;
          _categoriesMap = categoriesMap;
        });
      }
    } catch (e) {
      logger.e('Error loading automations: $e');
    }
  }

  String _getDateDisplayText(Set<int> days) {
    if (days.isEmpty) {
      return '';
    }

    if (days.length == 7) {
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

    final sortedDays = days.toList()
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

  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteAutomation(TransactionAutomationGroup automation) async {
    try {
      await sl<TransactionAutomationService>().deleteAutomation(
        automation.firstId,
      );
      await _loadAutomations();
    } catch (e) {
      logger.e('Error deleting automation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: AppTextConstants.historyAutomation),
      body: SafeArea(
        child: _automations.isEmpty
            ? Center(
                child: Text(
                  AppTextConstants.noData,
                  style: AppTextStyle.greyS14,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                itemCount: _automations.length,
                separatorBuilder: (context, index) => const AppDivider(),
                itemBuilder: (context, index) {
                  final automation = _automations[index];
                  final category =
                      _categoriesMap[automation.transactionCategoryId];

                  if (category == null) {
                    return const SizedBox.shrink();
                  }

                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => _deleteAutomation(automation),
                          backgroundColor: AppColorConstants.red,
                          foregroundColor: AppColorConstants.white,
                          icon: Icons.delete,
                          label: AppTextConstants.delete,
                        ),
                      ],
                    ),
                    child: _buildAutomationItem(automation, category),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildAutomationItem(
    TransactionAutomationGroup automation,
    TransactionCategory category,
  ) {
    final transactionType =
        automation.transactionType == TransactionType.income.typeIndex
        ? AppTextConstants.income
        : AppTextConstants.expense;

    return InkWell(
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppUIConstants.smallPadding,
        ),
        child: Row(
          spacing: AppUIConstants.defaultSpacing,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: GradientHelper.fromColorHexList(
                  category.gradientColors,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppUIConstants.smallPadding),
                child: SvgUtils.icon(
                  assetPath: category.pathAsset,
                  size: SvgSizeType.medium,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.title, style: AppTextStyle.blackS14Medium),
                  const SizedBox(height: AppUIConstants.smallSpacing),
                  Text(
                    _getDateDisplayText(automation.days),
                    style: AppTextStyle.greyS12,
                  ),
                  const SizedBox(height: AppUIConstants.smallSpacing),
                  Row(
                    children: [
                      Text(
                        _formatTime(automation.hour, automation.minute),
                        style: AppTextStyle.greyS12,
                      ),
                      const SizedBox(width: AppUIConstants.smallSpacing),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppUIConstants.smallPadding,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: automation.isActive
                              ? AppColorConstants.green
                              : AppColorConstants.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          automation.isActive
                              ? AppTextConstants.active
                              : AppTextConstants.inactive,
                          style: AppTextStyle.whiteS10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(transactionType, style: AppTextStyle.greyS12),
                const SizedBox(height: AppUIConstants.smallSpacing),
                Text(
                  FormatUtils.formatCurrency(automation.amount),
                  style: AppTextStyle.blackS14Medium,
                ),
              ],
            ),
            const SizedBox(width: AppUIConstants.defaultSpacing),
          ],
        ),
      ),
    );
  }
}
