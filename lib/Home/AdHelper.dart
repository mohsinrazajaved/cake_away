import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6654986669520896/4306077251';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6654986669520896/4860896439';
    }
    throw new UnsupportedError("Unsupported platform");
  }
}
