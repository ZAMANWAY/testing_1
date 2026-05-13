import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';

class InsightsSection extends StatelessWidget {
  const InsightsSection({
    super.key,
    required this.showToast,
    required this.onDismissToast,
  });

  final bool showToast;
  final VoidCallback onDismissToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
         spacing: 10,
          children: [
            Expanded(child: _CaloriesCard()),
         
            Expanded(child: _WeightCard()),
          ],
        ),

        SizedBox(height: 12.h(context)),

        _HydrationCard(),

      ],
    );
  }
}


class _CaloriesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
            height: 152.h(context),
      padding: const .all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
  
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '550',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 38,
                    fontWeight: .w600,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' Calories',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 18,
                    fontWeight: .w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h(context)),
          const AppText(
            '1950 Remaining',
            fontSize: 14,
            color: AppColors.textTertiary,
            fontWeight: .w500,
          ),
       const  Spacer(),
      
          const Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              AppText(
                '0',
                fontSize: 14,
                color: AppColors.textSecondary,
                    fontWeight: .w600,
              ),
              AppText(
                '2500',
                fontSize: 14,
                color: AppColors.textSecondary,
                 fontWeight: .w600,
              ),
            ],
          ),
          SizedBox(height: 4.h(context)),
   
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 5.h(context),
              decoration: const BoxDecoration(
                color: AppColors.progressTrack,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final filledWidth = (550 / 2500) * constraints.maxWidth;
                  final unfilledWidth = constraints.maxWidth - filledWidth;
                  return Row(
                    children: [
           
                      SizedBox(
                        width: filledWidth,
                        height: double.infinity,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF7BBDE2),
                                Color(0xFF69C0B1),
                                Color(0xFF60C198),
                              ],
                            ),
                          ),
                        ),
                      ),
                   
                      SizedBox(
                        width: unfilledWidth,
                        height: double.infinity,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFF464646),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _WeightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 152.h(context),
      padding: const .all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '75',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 40,
                    fontWeight: .w700,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' kg',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: .w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h(context)),
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.bullishIcon,
                width: 15.w(context),
                height: 15.h(context),
               
              ),
              SizedBox(width: 4.w(context)),
              const AppText(
                '+1.6kg',
                fontSize: 14,
                fontWeight: .w500,
                color: AppColors.textSecondary,
              ),
            ],
          ),
         const  Spacer(),
          const AppText(
            'Weight',
            fontSize: 18,
            fontWeight: .w700,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}


class _HydrationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
  
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: .only(topLeft: .circular(7),topRight: .circular(7)),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 130.h(context),
            child: Padding(
              padding:const .all(14),

              child: Row(
                crossAxisAlignment: .stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        const AppText(
                          '0%',
                          fontSize: 40,
                          fontWeight: .w600,
                          color: AppColors.accentBlue,
                          height: 1,
                        ),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            const AppText(
                              'Hydration',
                              fontSize: 18,
                              fontWeight: .w700,
                            ),
                            SizedBox(height: 2.h(context)),
                            const AppText(
                              'Log Now',
                              fontSize: 12,
                              fontWeight: .w400,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 6,
                    child: _HydrationChart(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: .center,
            padding: .symmetric(
              horizontal: 12.w(context),
              vertical: 12.h(context),
            ),
            decoration: const BoxDecoration(
              color: AppColors.toastBackground,
              borderRadius: .only(bottomLeft: .circular(7),bottomRight: .circular(7)),
            ),
            child: const AppText(
              '500 ml added to water log',
              fontSize: 14,
              fontWeight: .w400,
              color: AppColors.textPrimary,
            ),
          ),
       
        ],
      ),
    );
  }
}


class _HydrationChart extends StatelessWidget {
  const _HydrationChart();

  @override
  Widget build(BuildContext context) {
    final labelWidth = 22.w(context);
    final barLeft = labelWidth + 6.w(context);
    final tickWidth = 10.w(context);
    final topInset = 2.h(context);
    final bottomInset = 22.h(context);

    return Stack(
      children: [
        
        Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: labelWidth,
            child: const AppText(
              '2 L',
              fontSize: 10,
              fontWeight: .w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        Positioned(
          left: barLeft - tickWidth / 2 + 1,
          top: topInset + 4,
          child: Container(
            width: tickWidth,
            height: 3.h(context),
            decoration: BoxDecoration(
              color: AppColors.accentBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        Positioned(
          left: barLeft - tickWidth / 2 + 1,
          top: topInset + 10,
          bottom: bottomInset + 4,
          child: Column(
            mainAxisAlignment: .spaceBetween,
            children: List.generate(
              9,
              (i) {
                final isCenter = i == 4;
                return Container(
                  width: isCenter ? tickWidth : 2,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCenter
                        ? AppColors.accentBlue
                        : AppColors.accentBlue.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ),

        Positioned(
          left: 0,
          bottom: bottomInset - 6,
          child: SizedBox(
            width: labelWidth,
            child: const AppText(
              '0 L',
             fontSize: 10,
              fontWeight: .w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        Positioned(
          left: barLeft - tickWidth / 2 + 1,
          bottom: bottomInset,
          child: Container(
            width: tickWidth,
            height: 3.h(context),
            decoration: BoxDecoration(
              color: AppColors.accentBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        Positioned(
          left: barLeft + tickWidth / 2 + 2,
          right: 32.w(context),
          bottom: bottomInset + 1,
          child: Container(
            height: 1,
            color: AppColors.textTertiary.withValues(alpha: 0.45),
          ),
        ),

        Positioned(
          right: 0,
          bottom: bottomInset - 8,
          child: const AppText(
            '0ml',
            fontSize: 16,
            fontWeight: .w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}




