import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';
import '../controllers/plan_controller.dart';

const _kWeekColors = [
  Color(0xFF4855DF),
  Color(0xFF18AA99),
  Color(0xFFE57373),
  Color(0xFFFF9800),
  Color(0xFF9C27B0),
  Color(0xFF2196F3),
  Color(0xFF4CAF50),
  Color(0xFFFF5722),
];

const _kArmWorkout = PlanWorkout(
  id: 'arm_blaster',
  type: 'Arms Workout',
  name: 'Arm Blaster',
  duration: '25m - 30m',
  accentColor: AppColors.primary,
  iconAsset: AppAssets.armWoIcon,
);

const _kLegWorkout = PlanWorkout(
  id: 'leg_day_blitz',
  type: 'Leg Workout',
  name: 'Leg Day Blitz',
  duration: '25m - 30m',
  accentColor: AppColors.calendarDotBlue,
  iconAsset: AppAssets.legWoIcon,
);

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

List<List<DateTime>> _buildWeeks(DateTime periodStart) {
  final weeks = <List<DateTime>>[];
  DateTime cursor = periodStart;
  for (int w = 0; w < 8; w++) {
    final week = List.generate(7, (i) => cursor.add(Duration(days: i)));
    weeks.add(week);
    cursor = cursor.add(const Duration(days: 7));
  }
  return weeks;
}

DateTime _periodStart(DateTime now) {
  final month = now.month;
  int startMonth;
  if (month <= 2) {
    startMonth = 1;
  } else if (month <= 4) {
    startMonth = 3;
  } else if (month <= 6) {
    startMonth = 5;
  } else if (month <= 8) {
    startMonth = 7;
  } else if (month <= 10) {
    startMonth = 9;
  } else {
    startMonth = 11;
  }
  return DateTime(now.year, startMonth, 1);
}

int _findWeekIdx(List<List<DateTime>> weeks, DateTime date) {
  for (int i = 0; i < weeks.length; i++) {
    if (!date.isBefore(weeks[i].first) && !date.isAfter(weeks[i].last)) {
      return i;
    }
  }
  return 0;
}

String _keyFor(DateTime d) => '${d.year}-${d.month}-${d.day}';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  late final DateTime _today;
  late final List<List<List<DateTime>>> _allPeriods;
  late final int _currentWeekIdx;
  final GlobalKey _currentWeekKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _initialized = false;
  Timer? _autoScrollTimer;
  late final PlanController _controller;

  static const double _kScrollZone = 120.0;
  static const double _kMaxScrollSpeed = 18.0;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PlanController>();
    _today = _dateOnly(DateTime.now());

    final p0Start = _periodStart(_today);
    final p1Start = p0Start.add(const Duration(days: 56));
    _allPeriods = [_buildWeeks(p0Start), _buildWeeks(p1Start)];
    _currentWeekIdx = _findWeekIdx(_allPeriods[0], _today);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialized = true;
        _seedSchedule();
        _scrollToCurrentWeek();
      }
    });
  }

  void _seedSchedule() {
    final initial = <String, PlanWorkout>{};
    for (final day in _allPeriods[0][_currentWeekIdx]) {
      if (day.isAfter(_today)) {
        initial[_keyFor(day)] = _kArmWorkout;
        break;
      }
    }
    final nw = _allPeriods[1][0];
    initial[_keyFor(nw[3])] = _kLegWorkout;
    initial[_keyFor(nw[5])] = _kArmWorkout;
    _controller.initSchedule(initial);
  }

  void _scrollToCurrentWeek() {
    final ctx = _currentWeekKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final screenH = MediaQuery.of(context).size.height;
    final y = details.globalPosition.dy;
    double speed = 0;
    if (y > screenH - _kScrollZone) {
      final intensity = (y - (screenH - _kScrollZone)) / _kScrollZone;
      speed = _kMaxScrollSpeed * intensity.clamp(0.0, 1.0);
    } else if (y < _kScrollZone) {
      final intensity = (_kScrollZone - y) / _kScrollZone;
      speed = -_kMaxScrollSpeed * intensity.clamp(0.0, 1.0);
    }
    if (speed == 0) {
      _stopAutoScroll();
    } else {
      _startAutoScroll(speed);
    }
  }

  void _startAutoScroll(double speed) {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_scrollController.hasClients) return;
      final pos = _scrollController.position;
      final next = (_scrollController.offset + speed)
          .clamp(pos.minScrollExtent, pos.maxScrollExtent);
      _scrollController.jumpTo(next);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  String _periodLabel(List<List<DateTime>> weeks) {
    final start = weeks.first.first;
    final end = weeks.last.last;
    return '${DateFormat('MMM d').format(start)} – ${DateFormat('MMM d, yyyy').format(end)}';
  }

  List<Widget> _buildListChildren(PlanState planState) {
    final items = <Widget>[];
    for (int i = 0; i < 17; i++) {
      if (i == 8) {
        items.add(_PeriodSeparator(label: _periodLabel(_allPeriods[1])));
        continue;
      }
      final periodIdx = i < 8 ? 0 : 1;
      final weekIdx = i < 8 ? i : i - 9;
      final weekDays = _allPeriods[periodIdx][weekIdx];
      final weekColor = _kWeekColors[weekIdx % _kWeekColors.length];
      final isPastWeek = _dateOnly(weekDays.last).isBefore(_today);

      final weekWorkouts = <DateTime, PlanWorkout>{};
      for (final d in weekDays) {
        final k = _keyFor(d);
        final w = planState.schedule[k];
        if (w != null) weekWorkouts[d] = w;
      }
      final totalMin = weekWorkouts.length * 30;
      final isCurrentWeek = periodIdx == 0 && weekIdx == _currentWeekIdx;

      items.add(_WeekSection(
        key: isCurrentWeek ? _currentWeekKey : null,
        weekNumber: weekIdx + 1,
        weekColor: weekColor,
        days: weekDays,
        weekWorkouts: weekWorkouts,
        totalMinutes: totalMin,
        isPastWeek: isPastWeek,
        dragging: planState.dragging,
        today: _today,
        onDragUpdate: _handleDragUpdate,
        onDragStop: _stopAutoScroll,
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const _PlanHeader(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: _buildListChildren(controller.state),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanHeader extends StatelessWidget {
  const _PlanHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(
        horizontal: 24.w(context),
        vertical: 16.h(context),
      ),
      child: const Row(
        children: [
          AppText('Training Calendar', fontSize: 24, fontWeight: .w400),
          Spacer(),
          AppText('Save', fontSize: 18, fontWeight: .w700, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _PeriodSeparator extends StatelessWidget {
  const _PeriodSeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(vertical: 12.h(context), horizontal: 24.w(context)),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: AppColors.divider)),
          Padding(
            padding: .symmetric(horizontal: 12.w(context)),
            child: AppText(label, fontSize: 11, fontWeight: .w500, color: AppColors.textTertiary),
          ),
          Expanded(child: Container(height: 1, color: AppColors.divider)),
        ],
      ),
    );
  }
}

class _WeekSection extends StatelessWidget {
  const _WeekSection({
    super.key,
    required this.weekNumber,
    required this.weekColor,
    required this.days,
    required this.weekWorkouts,
    required this.totalMinutes,
    required this.isPastWeek,
    required this.dragging,
    required this.today,
    required this.onDragUpdate,
    required this.onDragStop,
  });

  final int weekNumber;
  final Color weekColor;
  final List<DateTime> days;
  final Map<DateTime, PlanWorkout> weekWorkouts;
  final int totalMinutes;
  final bool isPastWeek;
  final DragSession? dragging;
  final DateTime today;
  final void Function(DragUpdateDetails) onDragUpdate;
  final VoidCallback onDragStop;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlanController>();
    final start = days.first;
    final end = days.last;
    final startLabel = DateFormat('MMMM d').format(start);
    final endLabel = DateFormat('d').format(end);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [weekColor, weekColor.withValues(alpha: 0.35)],
            ),
          ),
        ),
        Padding(
          padding: .fromLTRB(24.w(context), 16.h(context), 24.w(context), 4.h(context)),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Container(
                    width: 3.w(context),
                    height: 18.h(context),
                    decoration: BoxDecoration(color: weekColor, borderRadius: BorderRadius.circular(2)),
                  ),
                  SizedBox(width: 8.w(context)),
                  AppText('Week $weekNumber/8', fontSize: 18, fontWeight: .w700),
              
                 
                ],
              ),
              SizedBox(height: 4.h(context)),
              Padding(
                padding: .only(left: 11.w(context)),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppText('$startLabel – $endLabel', fontSize: 16, fontWeight: .w400, color: AppColors.textSecondary),
                 if (totalMinutes > 0)
                    AppText('Total: ${totalMinutes}min', fontSize: 16, fontWeight: .w400, color: AppColors.textSecondary),  ],
                ),
              ),
            ],
          ),
        ),
        ...days.map((day) {
          final workout = weekWorkouts[day];
          final isDraggingFromHere = dragging != null && dragging!.originalDate == day && workout != null;
          final isDropTarget = dragging != null && dragging!.currentDate == day;
          return _DayRow(
            date: day,
            workout: workout,
            isPastWeek: isPastWeek,
            isDraggingFromHere: isDraggingFromHere,
            isDropTarget: isDropTarget,
            dragging: dragging,
            today: today,
            onDragStart: (d, w) => controller.startDrag(d, w),
            onDragTarget: (d) => controller.updateDragTarget(d),
            onDrop: (target) => controller.drop(target, today),
            onDragUpdate: onDragUpdate,
            onDragStop: onDragStop,
          );
        }),
        SizedBox(height: 4.h(context)),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.date,
    required this.workout,
    required this.isPastWeek,
    required this.isDraggingFromHere,
    required this.isDropTarget,
    required this.dragging,
    required this.today,
    required this.onDragStart,
    required this.onDragTarget,
    required this.onDrop,
    required this.onDragUpdate,
    required this.onDragStop,
  });

  final DateTime date;
  final PlanWorkout? workout;
  final bool isPastWeek;
  final bool isDraggingFromHere;
  final bool isDropTarget;
  final DragSession? dragging;
  final DateTime today;
  final void Function(DateTime, PlanWorkout) onDragStart;
  final void Function(DateTime) onDragTarget;
  final void Function(DateTime) onDrop;
  final void Function(DragUpdateDetails) onDragUpdate;
  final VoidCallback onDragStop;

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final isPast = date.isBefore(today);
    final isToday = date == today;
    final canDrag = !isPastWeek && !isPast && !isToday;
    final dayLabel = _dayLabels[date.weekday - 1];
    final dayNum = date.day.toString();
    final hasWorkout = workout != null;
    final isDraggingActive = dragging != null;
    final showDropPreview = isDropTarget && isDraggingActive && !isDraggingFromHere && !hasWorkout;

    return DragTarget<PlanWorkout>(
      onWillAcceptWithDetails: (details) {
        if (!canDrag) return false;
        onDragTarget(date);
        return true;
      },
      onLeave: (_) {
        if (dragging != null) onDragTarget(dragging!.originalDate);
      },
      onAcceptWithDetails: (_) => onDrop(date),
      builder: (context, candidateData, _) {
        final isHighlighted = candidateData.isNotEmpty;
        return Column(
          children: [
            Container(height: 1, color: AppColors.divider),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              color: isHighlighted ? AppColors.surfaceCard.withValues(alpha: 0.5) : Colors.transparent,
              padding: .symmetric(horizontal: 24.w(context), vertical: 10.h(context)),
              child: Row(
                crossAxisAlignment: .center,
                children: [
                  SizedBox(
                    width: 44.w(context),
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(dayLabel, fontSize: 14, fontWeight: .w700,
                            color: isPast ? AppColors.textTertiary :hasWorkout ?AppColors.textPrimary : AppColors.textSecondary),
                        SizedBox(height: 2.h(context)),
                        AppText(dayNum, fontSize: 20, fontWeight: .w500,
                            color: isPast || isToday ? AppColors.textSecondary : hasWorkout ? AppColors.textPrimary : AppColors.textSecondary),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w(context)),
                  Expanded(
                    child: showDropPreview
                        ? _DropPlaceholder(workout: dragging!.workout)
                        : hasWorkout
                            ? _buildCard(context, workout!, canDrag)
                            : const SizedBox(height: 64),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, PlanWorkout w, bool canDrag) {
    if (!canDrag) return _WorkoutPlanCard(workout: w);

    final sizer = AppSizer.of(context);
    final cardWidth = MediaQuery.of(context).size.width - 48 - 44 - 8;

    final handle = Draggable<PlanWorkout>(
      data: w,
      onDragStarted: () {
        HapticFeedback.mediumImpact();
        onDragStart(date, w);
      },
      onDragUpdate: onDragUpdate,
      onDragEnd: (details) {
        onDragStop();
        if (!details.wasAccepted) onDrop(date);
      },
      onDraggableCanceled: (vel, pos) => onDragStop(),
      feedback: AppSizer(
        screenWidth: sizer.screenWidth,
        screenHeight: sizer.screenHeight,
        scaleWidth: sizer.scaleWidth,
        scaleHeight: sizer.scaleHeight,
        designWidth: sizer.designWidth,
        designHeight: sizer.designHeight,
        isTablet: sizer.isTablet,
        isPortrait: sizer.isPortrait,
        isLandscape: sizer.isLandscape,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: cardWidth,
            child: Opacity(opacity: 0.9, child: _WorkoutPlanCard(workout: w)),
          ),
        ),
      ),
      childWhenDragging: const Opacity(opacity: 0.3, child: _DragHandle()),
      child: const _DragHandle(),
    );

    return Opacity(
      opacity: isDraggingFromHere ? 0.25 : 1.0,
      child: _WorkoutPlanCard(workout: w, dragHandle: handle),
    );
  }
}

class _DropPlaceholder extends StatelessWidget {
  const _DropPlaceholder({required this.workout});

  final PlanWorkout workout;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 64.h(context),
      decoration: BoxDecoration(
        color: workout.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: workout.accentColor.withValues(alpha: 0.4), width: 1.5),
      ),
    );
  }
}

class _WorkoutPlanCard extends StatelessWidget {
  const _WorkoutPlanCard({required this.workout, this.dragHandle});

  final PlanWorkout workout;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            width: 6.w(context),
            height: 64.h(context),
            decoration: BoxDecoration(
              color: workout.accentColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            ),
          ),
          SizedBox(width: 10.w(context)),
          dragHandle ?? const _DragHandle(),
          SizedBox(width: 10.w(context)),
          Expanded(
            child: Padding(
              padding: .symmetric(vertical: 12.h(context)),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _WorkoutBadge(workout: workout),
                  SizedBox(height: 6.h(context)),
                  AppText(workout.name, fontSize: 14, fontWeight: .w400),
                ],
              ),
            ),
          ),
          Padding(
            padding: .only(right: 12.w(context)),
            child: AppText(workout.duration, fontSize: 14, fontWeight: .w400, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _WorkoutBadge extends StatelessWidget {
  const _WorkoutBadge({required this.workout});

  final PlanWorkout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 8.w(context), vertical: 3.h(context)),
      decoration: BoxDecoration(
        color: workout.accentColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (workout.iconAsset != null) ...
            [
              SvgPicture.asset(
                workout.iconAsset!,
                width: 11.w(context),
                height: 11.h(context),
                colorFilter: ColorFilter.mode(workout.accentColor, BlendMode.srcIn),
              ),
              SizedBox(width: 4.w(context)),
            ],
          AppText(workout.type, fontSize: 10, fontWeight: .w600, color: workout.accentColor),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.dragIcon,
      width: 14.w(context),
      colorFilter: const ColorFilter.mode(AppColors.textTertiary, BlendMode.srcIn),
    );
  }
}
