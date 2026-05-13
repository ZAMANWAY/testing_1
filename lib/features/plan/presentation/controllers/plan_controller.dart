import 'package:flutter/material.dart';
import 'package:get/get.dart';

final class PlanWorkout {
  const PlanWorkout({
    required this.id,
    required this.type,
    required this.name,
    required this.duration,
    required this.accentColor,
    this.iconAsset,
  });

  final String id;
  final String type;
  final String name;
  final String duration;
  final Color accentColor;
  final String? iconAsset;
}

final class DragSession {
  const DragSession({
    required this.workout,
    required this.originalDate,
    required this.currentDate,
  });

  final PlanWorkout workout;
  final DateTime originalDate;
  final DateTime currentDate;

  DragSession copyWith({DateTime? currentDate}) => DragSession(
        workout: workout,
        originalDate: originalDate,
        currentDate: currentDate ?? this.currentDate,
      );
}

final class PlanState {
  const PlanState({
    required this.schedule,
    required this.dragging,
  });

  final Map<String, PlanWorkout> schedule;
  final DragSession? dragging;

  PlanState copyWith({
    Map<String, PlanWorkout>? schedule,
    Object? dragging = _sentinel,
  }) =>
      PlanState(
        schedule: schedule ?? this.schedule,
        dragging: dragging == _sentinel ? this.dragging : dragging as DragSession?,
      );

  static const _sentinel = Object();
}

class PlanController extends GetxController {
  PlanState state = const PlanState(schedule: {}, dragging: null);

  String _keyFor(DateTime d) => '${d.year}-${d.month}-${d.day}';

  void initSchedule(Map<String, PlanWorkout> initial) {
    state = state.copyWith(schedule: Map.of(initial));
    update();
  }

  void startDrag(DateTime fromDate, PlanWorkout workout) {
    state = state.copyWith(
      dragging: DragSession(
        workout: workout,
        originalDate: fromDate,
        currentDate: fromDate,
      ),
    );
    update();
  }

  void updateDragTarget(DateTime date) {
    final d = state.dragging;
    if (d == null) return;
    state = state.copyWith(dragging: d.copyWith(currentDate: date));
    update();
  }

  void cancelDrag() {
    state = state.copyWith(dragging: null);
    update();
  }

  void drop(DateTime targetDate, DateTime today) {
    final session = state.dragging;
    if (session == null) return;

    state = state.copyWith(dragging: null);

    final targetOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    if (targetOnly.isBefore(todayOnly) || targetOnly == todayOnly) {
      update();
      return;
    }

    final targetKey = _keyFor(targetDate);
    final originKey = _keyFor(session.originalDate);

    if (state.schedule.containsKey(targetKey)) {
      update();
      return;
    }

    final updated = Map<String, PlanWorkout>.of(state.schedule);
    updated.remove(originKey);
    updated[targetKey] = session.workout;
    state = state.copyWith(schedule: updated);
    update();
  }
}
