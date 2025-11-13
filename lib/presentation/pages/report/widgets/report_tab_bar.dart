import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class ReportTabBar extends StatelessWidget {
  const ReportTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (p, c) => p.selectedTabIndex != c.selectedTabIndex,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppUIConstants.smallPadding,
          ),
          child: AppTabView<ReportType>(
            types: ExReportType.reportTypes,
            selectedIndex: state.selectedTabIndex,
            getDisplayName: (t) => t.displayName,
            getTypeIndex: (t) => t.typeIndex,
            onTabSelected: (index) {
              context.read<ReportBloc>().add(
                ReportEvent.changeTab(index: index),
              );
            },
          ),
        );
      },
    );
  }
}
