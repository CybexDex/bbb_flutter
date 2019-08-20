import 'package:bbb_flutter/shared/ui_common.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Palette.backButtonColor, //change your color here
        ),
        centerTitle: true,
        title: Text(I18n.of(context).share, style: StyleFactory.title),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
      ),
      body: Container(
        child: Image.asset(R.resAssetsIconsShare),
      ),
    );
  }
}
