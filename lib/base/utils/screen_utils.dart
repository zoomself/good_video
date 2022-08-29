import 'dart:ui';

class ScreenUtils {
  ScreenUtils._();

  ///获取屏幕宽度
  static double getScreenWidth() {
    return window.physicalSize.width / window.devicePixelRatio;
  }
  ///获取屏幕高度
  static double getScreenHeight() {
    return window.physicalSize.height / window.devicePixelRatio;
  }
}
