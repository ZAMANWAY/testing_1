import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum WorkoutType { armDay, legDay, chestDay, backDay, rest }

class WeekDay {
  const WeekDay({
    required this.date,
    required this.workoutType,
  });

  final DateTime date;
  final WorkoutType workoutType;

  bool get hasArmDay   => workoutType == WorkoutType.armDay;
  bool get hasLegDay   => workoutType == WorkoutType.legDay;
  bool get hasChestDay => workoutType == WorkoutType.chestDay;
  bool get hasBackDay  => workoutType == WorkoutType.backDay;
}

class HomeController extends GetxController {
  late DateTime selectedDate;
  late List<WeekDay> weekDays;

  final int totalWeeks = 4;
  bool showWaterToast = true;
  bool isDaytime = true;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    weekDays = _buildWeekDays(selectedDate);
    isDaytime = _checkIsDaytime();
  }

  int get currentWeekNumber =>
      (((selectedDate.day - 1) ~/ 7) + 1).clamp(1, totalWeeks);

  String get formattedToday {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final pattern = isToday ? "'Today,' d MMM yyyy" : 'EEEE, d MMM yyyy';
    return DateFormat(pattern).format(selectedDate);
  }

  static bool _checkIsDaytime() {
    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 20;
  }

  static WorkoutType _workoutForWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return WorkoutType.armDay;
      case 2:
        return WorkoutType.legDay;
      case 3:
        return WorkoutType.armDay;
      case 5:
        return WorkoutType.legDay;
      case 6:
        return WorkoutType.armDay;
      default:
        return WorkoutType.rest;
    }
  }

  List<WeekDay> _buildWeekDays(DateTime selected) {
    final monday = selected.subtract(Duration(days: selected.weekday - 1));
    return List.generate(7, (i) {
      final d = monday.add(Duration(days: i));
      return WeekDay(
        date: d,
        workoutType: _workoutForWeekday(d.weekday),
      );
    });
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    weekDays = _buildWeekDays(date);
    update();
  }

  void dismissToast() {
    showWaterToast = false;
    update();
  }
}
