import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';
import '../controllers/home_controller.dart';
import '../widgets/calendar_bottom_sheet.dart';
import '../widgets/insights_section.dart';
import '../widgets/week_strip.dart';
import '../widgets/workout_card.dart';
import '../widgets/workout_details_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: .symmetric(horizontal: 24.w(context), vertical: 16.h(context)),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(AppAssets.notificationIcon, width: 24.w(context), height: 24.h(context)),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _showCalendar(context, controller),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(AppAssets.durationIcon, width: 20.w(context), height: 20.h(context)),
                            SizedBox(width: 4.w(context)),
                            AppText('Week ${controller.currentWeekNumber}/${controller.totalWeeks}', fontSize: 14, fontWeight: .w700),
                            Icon(Icons.arrow_drop_down, color: AppColors.textPrimary, size: 20.w(context)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppText(controller.formattedToday, fontSize: 16, fontWeight: .w700),
                  ),
                  const SizedBox(height: 10),
                  WeekStrip(
                    days: controller.weekDays,
                    selectedDate: controller.selectedDate,
                    onDayTap: (date) {
                      final tappedDay = controller.weekDays.firstWhere(
                        (d) => d.date.year == date.year && d.date.month == date.month && d.date.day == date.day,
                        orElse: () => WeekDay(date: date, workoutType: WorkoutType.rest),
                      );
                      controller.selectDate(date);
                      if (tappedDay.workoutType == WorkoutType.armDay || tappedDay.workoutType == WorkoutType.legDay) {
                        WorkoutDetailsDialog.show(context, date: date, workoutType: tappedDay.workoutType);
                      }
                    },
                  ),
                  SizedBox(height: 14.h(context)),
                  Container(
                    margin: .symmetric(vertical: 10.h(context)),
                    width: 40.w(context),
                    height: 4.h(context),
                    decoration: BoxDecoration(color: const Color(0xFF282A39), borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: .only(bottom: 24.h(context)),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            children: [
                              const AppText('Workouts', fontSize: 24, fontWeight: .w600),
                              const Spacer(),
                              SvgPicture.asset(
                                controller.isDaytime ? AppAssets.dayIcon : AppAssets.nightIcon,
                                width: 20.w(context),
                                height: 20.h(context),
                              ),
                              SizedBox(width: 6.w(context)),
                              const AppText('9\u00B0', fontSize: 25, fontWeight: .w500, color: AppColors.textPrimary),
                            ],
                          ),
                          SizedBox(height: 14.h(context)),
                          WorkoutCard(date: 'December 22 - 25m - 30m', title: 'Upper Body', onTap: () {}),
                          const SizedBox(height: 24),
                          const AppText('My Insights', fontSize: 24, fontWeight: .w600),
                          const SizedBox(height: 14),
                          InsightsSection(showToast: controller.showWaterToast, onDismissToast: controller.dismissToast),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCalendar(BuildContext context, HomeController controller) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => CalendarBottomSheet(
        selectedDate: controller.selectedDate,
        onDateSelected: (d) {
          controller.selectDate(d);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
