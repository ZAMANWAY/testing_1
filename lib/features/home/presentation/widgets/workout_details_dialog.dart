import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';
import '../controllers/home_controller.dart';

class WorkoutDetailsDialog extends StatelessWidget {
  const WorkoutDetailsDialog({
    super.key,
    required this.date,
    required this.workoutType,
  });

  final DateTime date;
  final WorkoutType workoutType;

  static Future<void> show(
    BuildContext context, {
    required DateTime date,
    required WorkoutType workoutType,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => SizerBuilder(
        child: WorkoutDetailsDialog(
          date: date,
          workoutType: workoutType,
        ),
      ),
    );
  }

  bool get _isArm => workoutType == WorkoutType.armDay;

  Color get _accent =>
      _isArm ? AppColors.calendarDotGreen : AppColors.calendarDotBlue;

  String get _iconAsset =>
      _isArm ? AppAssets.armWoIcon : AppAssets.legWoIcon;

  String get _type => _isArm ? 'Arms Workout' : 'Leg Workout';

  String get _title => _isArm ? 'Arm Blaster' : 'Leg Day Blitz';

  String get _duration => '25m - 30m';

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, d MMM yyyy').format(date);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: .symmetric(horizontal: 28.w(context)),
      child: Container(
        padding: .fromLTRB(
          20.w(context),
          18.h(context),
          20.w(context),
          20.h(context),
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(
                    formattedDate,
                    fontSize: 13,
                    fontWeight: .w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close,
                    size: 20.w(context),
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h(context)),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6.w(context),
                    height: 72.h(context),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w(context)),
                  Expanded(
                    child: Padding(
                      padding: .symmetric(vertical: 12.h(context)),
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: .symmetric(
                              horizontal: 8.w(context),
                              vertical: 3.h(context),
                            ),
                            decoration: BoxDecoration(
                              color: _accent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  _iconAsset,
                                  width: 11.w(context),
                                  height: 11.h(context),
                                  colorFilter: ColorFilter.mode(
                                    _accent,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 4.w(context)),
                                AppText(
                                  _type,
                                  fontSize: 10,
                                  fontWeight: .w600,
                                  color: _accent,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6.h(context)),
                          AppText(
                            _title,
                            fontSize: 14,
                            fontWeight: .w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: .only(right: 14.w(context)),
                    child: AppText(
                      _duration,
                      fontSize: 13,
                      fontWeight: .w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
