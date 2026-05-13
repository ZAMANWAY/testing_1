import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';
import '../controllers/mood_controller.dart';



class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoodController>(
      builder: (controller) {
        final state = controller.state;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: _TopGradientGlow(),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: .fromLTRB(
                      24.w(context), 20.h(context), 24.w(context), 0),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const AppText('Mood',
                          fontSize: 32, fontWeight: .w400),
                      SizedBox(height: 16.h(context)),
                      const AppText('Start your day',
                          fontSize: 18,
                          fontWeight: .w400,
                          color: AppColors.textPrimary),
                      SizedBox(height: 4.h(context)),
                      const AppText('How are you feeling at the\nMoment?',
                          fontSize: 24, fontWeight: .w600),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _MoodRing(
                      thumbAngleDeg: state.thumbAngleDeg,
                      selectedMood: state.selectedMood,
                      onThumbAngleChanged: controller.updateThumbAngle,
                      onDragEnd: controller.snapToMood,
                    ),
                  ),
                ),
                AnimatedScale(
                  scale: _labelScale(state),
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 360),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.70, end: 1.0)
                            .animate(CurvedAnimation(
                                parent: anim, curve: Curves.easeOut)),
                        child: child,
                      ),
                    ),
                    child: SizedBox(
                      key: ValueKey(state.selectedMood),
                      width: double.infinity,
                      child: Center(
                        child: AppText(
                          state.selectedMood.label,
                          fontSize: 28,
                          fontWeight: .w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100.h(context)),
                Padding(
                  padding: .fromLTRB(
                      24.w(context), 0, 24.w(context), 32.h(context)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56.h(context),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const AppText('Continue',
                          fontSize: 16,
                          fontWeight: .w600,
                          color: AppColors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        );
      },
    );
  }
  double _labelScale(MoodState state) {
  final diff =
      ((state.thumbAngleDeg - state.selectedMood.angle + 540) % 360) - 180;
  final progress = ((diff + 45) / 90).clamp(0.0, 1.0);
  return 0.85 + progress * 0.30;
}
}

class _MoodRing extends StatelessWidget {
  const _MoodRing({
    required this.thumbAngleDeg,
    required this.selectedMood,
    required this.onThumbAngleChanged,
    required this.onDragEnd,
  });

  final double thumbAngleDeg;
  final MoodType selectedMood;
  final void Function(double angleDeg) onThumbAngleChanged;
  final VoidCallback onDragEnd;

  void _handlePan(Offset localPos, double size) {
    final dx = localPos.dx - size / 2;
    final dy = localPos.dy - size / 2;
    final angleDeg = (math.atan2(dx, -dy) * 180 / math.pi + 360) % 360;
    onThumbAngleChanged(angleDeg);
  }

  @override
  Widget build(BuildContext context) {
    final ringSize =
        math.min(MediaQuery.of(context).size.width * 0.80, 310.0);
    final strokeW = ringSize * 0.118;
    final thumbR = strokeW * 0.72;
    final emojiSize = ringSize * 0.40;
    final ringRadius = (ringSize - strokeW) / 2;

    final angleRad = (thumbAngleDeg - 90) * math.pi / 180;
    final thumbCx = ringSize / 2 + ringRadius * math.cos(angleRad);
    final thumbCy = ringSize / 2 + ringRadius * math.sin(angleRad);

    final diff = ((thumbAngleDeg - selectedMood.angle + 540) % 360) - 180;
    final progress = ((diff + 45) / 90).clamp(0.0, 1.0);
    final emojiScale = 0.85 + progress * 0.30;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (d) => _handlePan(d.localPosition, ringSize),
      onPanUpdate: (d) => _handlePan(d.localPosition, ringSize),
      onPanEnd: (_) => onDragEnd(),
      child: SizedBox(
        width: ringSize,
        height: ringSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(ringSize, ringSize),
              painter: const _RingPainter(),
            ),
            Positioned(
              left: thumbCx - thumbR,
              top: thumbCy - thumbR,
              child: Container(
                width: thumbR * 2,
                height: thumbR * 2,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              child: AnimatedScale(
                scale: emojiScale,
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 360),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.70, end: 1.0)
                          .animate(CurvedAnimation(
                              parent: anim, curve: Curves.easeOut)),
                      child: child,
                    ),
                  ),
                  child: SvgPicture.asset(
                    selectedMood.iconAsset,
                    key: ValueKey(selectedMood),
                    width: emojiSize,
                    height: emojiSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter();

  static const _calmColor = Color(0xFF6EB9AD);
  static const _contentColor = Color(0xFFC9BBEF);
  static const _peacefulColor = Color(0xFFF28DB3);
  static const _happyColor = Color(0xFFF99955);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeW = size.width * 0.118;
    final radius = (size.width - strokeW) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final gradientShader = const SweepGradient(
      colors: [
        _calmColor,
        _calmColor,
        _contentColor,
        _peacefulColor,
        _happyColor,
        _calmColor,
      ],
      stops: [0.0, 0.0833, 0.3333, 0.5833, 0.8333, 1.0],
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    ).createShader(rect);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt
      ..shader = gradientShader;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, paint);

    const tickAnglesDeg = [
      -90, -120, -150, 180, 150, 120,
      90, 60, 30, 0, -30, -60,
    ];
    final tickPaint = Paint()
      ..color = AppColors.white.withAlpha(50)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt;
    final outerR = radius + strokeW / 2;
    final innerR = radius - strokeW / 2;
    for (final deg in tickAnglesDeg) {
      final angle = deg * math.pi / 180;
      final cos = math.cos(angle);
      final sin = math.sin(angle);
      final p1 = Offset(center.dx + cos * outerR, center.dy + sin * outerR);
      final p2 = Offset(center.dx + cos * innerR, center.dy + sin * innerR);
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _TopGradientGlow extends StatelessWidget {
  const _TopGradientGlow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -1.0),
            radius: 1.2,
            focal: const Alignment(0, -1.0),
            focalRadius: 0.05,
            colors: [
              const Color(0xFF2C4A66),
              const Color(0xFF1F3A55).withValues(alpha: 0.75),
              const Color(0xFF193242).withValues(alpha: 0.30),
              Colors.transparent,
            ],
            stops: const [0.0, 0.35, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}
