import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';
import '../controllers/home_controller.dart';

class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onDayTap,
  });

  final List<WeekDay> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['M', 'TU', 'W', 'TH', 'F', 'SA', 'SU'];
    return Padding(
      padding:  .symmetric(horizontal: 6.w(context)),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: days.map((day) {
          final isSelected = day.date.day == selectedDate.day &&
              day.date.month == selectedDate.month;
          final dayLabel = dayLabels[day.date.weekday - 1];
          final dayNum = day.date.day.toString();
      
          return GestureDetector(
            onTap: () => onDayTap(day.date),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 40.w(context),
              child: Column(
                children: [
                  AppText(
                    dayLabel,
                    fontSize: 12,
                    fontWeight: .w700,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 8.h(context)),
                  Container(
                    width: 34.w(context),
                    height: 34.h(context),
                    decoration: BoxDecoration(
      
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: AppColors.calendarSelectedBorder,
                              width: 2,
                            )
                          : null,
                      color:isSelected ?AppColors.calendarSelectedBorder.withAlpha(19): AppColors.surfaceCard,
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      dayNum,
                      fontSize: 14,
                      fontWeight:
                          .w700,
                      color:AppColors.textPrimary
                        
                    ),
                  ),
                  SizedBox(height: 6.h(context)),
                  _buildDots(context, day),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDots(BuildContext context, WeekDay day) {
    final Color? dotColor;
    switch (day.workoutType) {
      case WorkoutType.armDay:
        dotColor = AppColors.calendarDotGreen;
        break;
      case WorkoutType.legDay:
        dotColor = AppColors.calendarDotBlue;
        break;
      case WorkoutType.chestDay:
      case WorkoutType.backDay:
      case WorkoutType.rest:
        dotColor = null;
        break;
    }

    if (dotColor == null) return SizedBox(height: 6.h(context));

    return Container(
      width: 6.w(context),
      height: 6.h(context),
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
    );
  }
}
