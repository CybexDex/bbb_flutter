import 'package:bbb_flutter/screen/homeNav.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      imageBackground: AssetImage(R.resAssetsIconsBbbSplash),
      navigateAfterSeconds: MainPage(),
      loaderColor: Colors.transparent,
    );
  }
}
