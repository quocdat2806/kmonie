import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class MyAppPage extends StatelessWidget {
  const MyAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: 'Ứng dụng của chúng tôi'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            children: [
              _buildAppItem(
                context: context,
                icon:
                    'https://play-lh.googleusercontent.com/8ddL1kuoNUB5vUvgDVjYY3_6HwQcrg1K2fd_R8soD-e2QYj8fT9cfhqr3CndW8sVfkxC=w240-h480-rw',
                title: 'iTask - Thói quen & Lịch',
                rating: 4.5,
                onTap: () {
                  // TODO: Open iTask app or store
                },
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildAppItem(
                context: context,
                icon:
                    'https://play-lh.googleusercontent.com/8ddL1kuoNUB5vUvgDVjYY3_6HwQcrg1K2fd_R8soD-e2QYj8fT9cfhqr3CndW8sVfkxC=w240-h480-rw',
                title: 'Tử Vi Hàng Ngày-Cung Hoàng Đạo',
                rating: 4.5,
                onTap: () {
                  // TODO: Open horoscope app or store
                },
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildAppItem(
                context: context,
                icon:
                    'https://play-lh.googleusercontent.com/8ddL1kuoNUB5vUvgDVjYY3_6HwQcrg1K2fd_R8soD-e2QYj8fT9cfhqr3CndW8sVfkxC=w240-h480-rw',
                title: 'Magic Quotes -daily motivation',
                rating: 4.5,
                onTap: () {
                  // TODO: Open quotes app or store
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppItem({
    required BuildContext context,
    required String icon,
    required String title,
    required double rating,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppColorConstants.white,
          borderRadius: BorderRadius.circular(
            AppUIConstants.defaultBorderRadius,
          ),
          border: Border.all(color: AppColorConstants.greyWhite),
        ),
        child: Row(
          children: [
            // AppCircleImage(
            //   imageUrl: icon,
            //   size: 60,
            // ),
            const SizedBox(width: AppUIConstants.defaultSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.blackS16Bold),
                  const SizedBox(height: 4),
                  _buildRatingWidget(rating),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColorConstants.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingWidget(double rating) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return const Icon(Icons.star, color: Colors.orange, size: 16);
          } else if (index == rating.floor() && rating % 1 != 0) {
            return const Icon(Icons.star_half, color: Colors.orange, size: 16);
          } else {
            return const Icon(
              Icons.star_border,
              color: Colors.orange,
              size: 16,
            );
          }
        }),
        const SizedBox(width: 4),
        Text('$rating', style: AppTextStyle.greyS12),
      ],
    );
  }
}
