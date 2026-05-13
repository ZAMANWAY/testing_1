import 'package:get/get.dart';

import '../../features/home/presentation/controllers/home_controller.dart';
import '../../features/main_dashboard/presentation/controllers/main_dashboard_controller.dart';
import '../../features/mood/presentation/controllers/mood_controller.dart';
import '../../features/plan/presentation/controllers/plan_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainDashboardController>(() => MainDashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PlanController>(() => PlanController());
    Get.lazyPut<MoodController>(() => MoodController());
  }
}
