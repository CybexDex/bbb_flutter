import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Consumer<UserManager>(
            builder: (context, userMg, child) => DrawerHeader(
              child: Column(
                children: <Widget>[
                  Align(
                    child: GestureDetector(
                      child: ImageFactory.back,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  Text("${userMg.user.balances.positions.first.quantity}")
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              I18n.of(context).topUp,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
          ListTile(
            title: Text(
              I18n.of(context).withdraw,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
          ListTile(
            title: Text(
              I18n.of(context).cashRecords,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
          ListTile(
            title: Text(
              I18n.of(context).transactionRecords,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
        ],
      ),
    );
  }
}
