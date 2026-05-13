import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.date,
    required this.title,
    required this.onTap,
  });

  final String date;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 6.w(context),
              height: 72.h(context),
              decoration: const BoxDecoration(
                color: AppColors.workoutAccentBar,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            SizedBox(width: 14.w(context)),
            Expanded(
              child: Padding(
                padding: .symmetric(vertical: 14.h(context)),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      date,
                      fontSize: 12,
                      fontWeight: .w700,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: 4.h(context)),
                    AppText(
                      title,
                      fontSize: 24,
                      fontWeight: .w700,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: .only(right: 16.w(context)),
              child: SvgPicture.asset(
                AppAssets.arrowRightIcon,
                width: 20.w(context),
                height: 20.h(context),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
