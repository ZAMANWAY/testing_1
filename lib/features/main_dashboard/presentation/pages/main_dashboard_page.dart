import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../mood/presentation/pages/mood_page.dart';
import '../../../plan/presentation/pages/plan_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../controllers/main_dashboard_controller.dart';

class MainDashboardPage extends StatelessWidget {
  const MainDashboardPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    PlanPage(),
    MoodPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainDashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: controller.currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _BottomNav(
          currentIndex: controller.currentIndex,
          onTap: controller.setTab,
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: AppAssets.nutritionIcon, label: 'Nutrition'),
    _NavItem(icon: AppAssets.planIcon, label: 'Plan'),
    _NavItem(icon: AppAssets.moodIcon, label: 'Mood'),
    _NavItem(icon: AppAssets.profileIcon, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h(context),
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == currentIndex;
              final item = _items[i];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      
                      SvgPicture.asset(
                        item.icon,
                        width: 24.w(context),
                        height: 24.h(context),
                        colorFilter: ColorFilter.mode(
                          selected
                              ? AppColors.white
                              : AppColors.navUnselected,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 4.h(context)),
                      AppText(
                        item.label,
                        fontSize: 14,
                        fontWeight: .w400,
                        color: selected
                            ? AppColors.white
                            : AppColors.navUnselected,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
