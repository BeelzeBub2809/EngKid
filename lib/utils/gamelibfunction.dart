import 'package:flame/components.dart';

class GameLibFunction {
  GameLibFunction._();
  static final Vector2 designScreen = Vector2(1920, 1080);
  static Vector2 scaleForCurrentVector2(
      Vector2 screenSize, Vector2 designScreen, Vector2 designOut,
      {int desire = 0}) {
    // 0: scale by width
    // 1: scale by height
    // 2: scale by both
    late Vector2 desireResult;
    if (desire == 0) {
      final double scale = screenSize[0] / designScreen[0];
      desireResult = designOut.scaled(scale);
    } else if (desire == 1) {
      final double scale = screenSize[1] / designScreen[1];
      desireResult = designOut.scaled(scale);
    } else {
      final double scaleX = screenSize[0] / designScreen[0];
      final double scaleY = screenSize[1] / designScreen[1];
      desireResult = Vector2(designOut[0] * scaleX, designOut[1] * scaleY);
    }
    return desireResult;
  }

  static double scaleForCurrentValue(
      Vector2 screenSize, Vector2 designScreen, double designOut,
      {int desire = 0}) {
    // 0: scale by width
    // 1: scale by height
    // 2: scale by both
    late double desireResult;
    if (desire == 0) {
      final double scale = screenSize[0] / designScreen[0];
      desireResult = designOut * scale;
    } else if (desire == 1) {
      final double scale = screenSize[1] / designScreen[1];
      desireResult = designOut * scale;
    }
    return desireResult;
  }
}
