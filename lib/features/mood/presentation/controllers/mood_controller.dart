import 'package:get/get.dart';


enum MoodType { calm, content, peaceful, happy }

extension MoodTypeX on MoodType {
  String get label => switch (this) {
        MoodType.calm => 'Calm',
        MoodType.content => 'Content',
        MoodType.peaceful => 'Peaceful',
        MoodType.happy => 'Happy',
      };

  String get iconAsset => switch (this) {
        MoodType.calm => 'assets/icons/calm_mood_icon.svg',
        MoodType.content => 'assets/icons/content_mood_icon.svg',
        MoodType.peaceful => 'assets/icons/peaceful_mood_icon.svg',
        MoodType.happy => 'assets/icons/happy_mood_icon.svg',
      };

  double get angle => switch (this) {
        MoodType.calm => 30.0,
        MoodType.content => 120.0,
        MoodType.peaceful => 210.0,
        MoodType.happy => 300.0,
      };
}

final class MoodState {
  const MoodState({
    required this.selectedMood,
    required this.thumbAngleDeg,
  });

  final MoodType selectedMood;

  final double thumbAngleDeg;
}

MoodType _moodForAngle(double deg) {
  final n = ((deg % 360) + 360) % 360;
  if (n >= 345 || n < 75) return MoodType.calm;
  if (n < 165) return MoodType.content;
  if (n < 255) return MoodType.peaceful;
  return MoodType.happy;
}

class MoodController extends GetxController {
  MoodState state = const MoodState(
    selectedMood: MoodType.calm,
    thumbAngleDeg: 30.0,
  );

  void updateThumbAngle(double angleDeg) {
    state = MoodState(
      selectedMood: _moodForAngle(angleDeg),
      thumbAngleDeg: angleDeg,
    );
    update();
  }

  void snapToMood() {
    state = MoodState(
      selectedMood: state.selectedMood,
      thumbAngleDeg: state.selectedMood.angle,
    );
    update();
  }
}
