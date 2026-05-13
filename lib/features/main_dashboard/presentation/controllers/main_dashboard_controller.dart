import 'package:get/get.dart';

class MainDashboardController extends GetxController {
  int currentIndex = 0;

  void setTab(int index) {
    currentIndex = index;
    update();
  }
}
