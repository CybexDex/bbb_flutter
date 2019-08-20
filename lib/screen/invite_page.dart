import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/invite_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class InvitePage extends StatefulWidget {
  InvitePage({Key key}) : super(key: key);

  @override
  State createState() => _InviteState();
}

class _InviteState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<InviteViewModel>(
      model: InviteViewModel(api: locator.get(), um: locator.get()),
      onModelReady: (model) => model.getRefer(),
      builder: (context, model, child) {
        print(model.referTopList);
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Palette.backButtonColor, //change your color here
            ),
            centerTitle: true,
            title:
                Text(I18n.of(context).inviteFriend, style: StyleFactory.title),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
          ),
          body: Container(
            color: Palette.inviteBackgroundColor,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    SafeArea(
                      child: Container(
                        color: Palette.inviteBackgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Stack(
                                children: <Widget>[
                                  SizedBox(height: 1, width: 1),
                                  Image.asset(R.resAssetsIconsImgBanner),
                                  Positioned(
                                    right: 30,
                                    top: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 3,
                                          bottom: 3),
                                      child: Text("规则",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Palette.pagePrimaryColor,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize: Dimen
                                                  .verySmallLabelFontSize)),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Palette.pagePrimaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: DecorationFactory
                                  .invitationContainerShadowDecoration,
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    color: Palette.inviteDivisionHeaderColor,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            "排名Top3",
                                            style: StyleFactory.buyUpOrderInfo,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 30, bottom: 20),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(R.resAssetsIconsIcTop2),
                                            SizedBox(height: 8),
                                            Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : model
                                                      ?.referTopList[1]?.name,
                                              style: StyleFactory
                                                  .dialogContentTitleStyle,
                                            ),
                                            Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : model
                                                      ?.referTopList[1]?.amount
                                                      ?.toStringAsFixed(4),
                                              style: StyleFactory
                                                  .dialogContentStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 30),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(R.resAssetsIconsIcTop1),
                                            SizedBox(height: 8),
                                            Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : model
                                                      ?.referTopList[0]?.name,
                                              style: StyleFactory
                                                  .dialogContentTitleStyle,
                                            ),
                                            Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : model
                                                      ?.referTopList[0]?.amount
                                                      ?.toStringAsFixed(4),
                                              style: StyleFactory
                                                  .dialogContentStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 30, bottom: 20),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(R.resAssetsIconsIcTop3),
                                            SizedBox(height: 8),
                                            Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : model
                                                      ?.referTopList[2]?.name,
                                              style: StyleFactory
                                                  .dialogContentTitleStyle,
                                            ),
                                            Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : model
                                                      ?.referTopList[2]?.amount
                                                      ?.toStringAsFixed(4),
                                              style: StyleFactory
                                                  .dialogContentStyle,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: DecorationFactory
                                  .invitationContainerShadowDecoration,
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    color: Palette.inviteDivisionHeaderColor,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            I18n.of(context).inviteReward,
                                            style: StyleFactory.buyUpOrderInfo,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(I18n.of(context).inviteReward,
                                          style: StyleFactory
                                              .dialogContentTitleStyle),
                                      Text(
                                        I18n.of(context).inviteRecommendSuc,
                                        style: StyleFactory
                                            .dialogContentTitleStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            model?.referUserAmount == null
                                                ? "--"
                                                : (model.referUserAmount.total -
                                                        model.referUserAmount
                                                            .pending)
                                                    .toStringAsFixed(2),
                                            style:
                                                StyleFactory.inviteAmountStyle,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("USDT",
                                              style:
                                                  StyleFactory.buyUpCellLabel)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            model.referralNumber.toString(),
                                            style:
                                                StyleFactory.inviteAmountStyle,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("人",
                                              style:
                                                  StyleFactory.buyUpCellLabel)
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(I18n.of(context).inviteMyPinCode,
                                          style: StyleFactory.subTitleStyle),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            locator
                                                .get<UserManager>()
                                                .user
                                                .name,
                                            style: StyleFactory.subTitleStyle,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: locator
                                                      .get<UserManager>()
                                                      .user
                                                      .name));
                                              showToast(context, false, "复制成功");
                                            },
                                            child: SvgPicture.asset(
                                                R.resAssetsIconsContentCopy),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(I18n.of(context).inviteMyRecommender,
                                          style: StyleFactory.subTitleStyle),
                                      model.referrer != null
                                          ? Text(
                                              model.referrer,
                                              style: StyleFactory.subTitleStyle,
                                            )
                                          : WidgetFactory.invitePeopleButton(
                                              onPressed: () {
                                              TextEditingController
                                                  textController =
                                                  TextEditingController();
                                              TextEditingController
                                                  passwordController =
                                                  TextEditingController();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DialogFactory
                                                        .addRefererDialog(
                                                            context,
                                                            controller:
                                                                textController,
                                                            controllerForPassword:
                                                                passwordController);
                                                  }).then((value) {
                                                if (value[0]) {
                                                  callRegister(
                                                      context, model, value[1]);
                                                }
                                              });
                                            })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: DecorationFactory
                                  .invitationContainerShadowDecoration,
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    color: Palette.inviteDivisionHeaderColor,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            I18n.of(context).inviteGainReward,
                                            style: StyleFactory.buyUpOrderInfo,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 32),
                                        child: Divider(
                                          height: 0,
                                          color: Palette.inviteAddButtonColor,
                                          endIndent: 50,
                                          indent: 50,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                            top: 20,
                                            bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              width: 70,
                                              child: Column(
                                                children: <Widget>[
                                                  WidgetFactory
                                                      .inviteStepsPills(
                                                          step: "1"),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    I18n.of(context)
                                                        .inviteThreeStepOne,
                                                    style: StyleFactory
                                                        .subTitleStyle,
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 80,
                                              child: Column(
                                                children: <Widget>[
                                                  WidgetFactory
                                                      .inviteStepsPills(
                                                          step: "2"),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    I18n.of(context)
                                                        .inviteThreeStepTwo,
                                                    style: StyleFactory
                                                        .subTitleStyle,
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 45,
                                              child: Column(
                                                children: <Widget>[
                                                  WidgetFactory
                                                      .inviteStepsPills(
                                                          step: "3"),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    I18n.of(context)
                                                        .inviteThreeStepThree,
                                                    style: StyleFactory
                                                        .subTitleStyle,
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: DecorationFactory
                                  .invitationContainerShadowDecoration,
                              margin: EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 20),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    color: Palette.inviteDivisionHeaderColor,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            I18n.of(context)
                                                .inviteRecommendation,
                                            style: StyleFactory.buyUpOrderInfo,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                            R.resAssetsIconsIcTitleLine),
                                      ],
                                    ),
                                  ),
                                  ListView.separated(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return Container(height: 10);
                                      },
                                      itemCount: model.referralList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(
                                                  model.referralList[index]
                                                      .referral,
                                                  style: StyleFactory
                                                      .dialogContentStyle),
                                              Text(
                                                  DateFormat("yyyy-MM-dd HH:mm")
                                                      .format(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              model
                                                                      .referralList[
                                                                          index]
                                                                      .ts *
                                                                  1000)),
                                                  style: StyleFactory
                                                      .dialogContentStyle)
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  callRegister(
      BuildContext context, InviteViewModel model, String referer) async {
    showLoading(context);
    RegisterRefResponseModel registerRefResponseModel =
        await model.postRefer(referrer: referer);

    if (registerRefResponseModel == null) {
      Navigator.of(context).pop();
      showToast(
        context,
        true,
        I18n.of(context).failToast,
      );
    } else {
      if (!registerRefResponseModel.success) {
        Navigator.of(context).pop();
        showToast(
          context,
          true,
          registerRefResponseModel.reason,
        );
      } else {
        Navigator.of(context).pop();
        model.getRefer();
        showToast(
          context,
          false,
          I18n.of(context).successToast,
        );
      }
    }
  }
}
