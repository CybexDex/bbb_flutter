import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/logic/invite_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class InvitePage extends StatefulWidget {
  InvitePage({Key key}) : super(key: key);

  @override
  State createState() => _InviteState();
}

class _InviteState extends State<InvitePage> {
  GlobalKey _listviewContainer = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BaseWidget<InviteViewModel>(
      model: InviteViewModel(
          api: locator.get(),
          nodeApi: locator.get(),
          refm: locator.get(),
          um: locator.get(),
          bbbapi: locator.get()),
      onModelReady: (model) async {
        model.getRefer();
        model.getUserRebate();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Center(
                    child: Text(
                      I18n.of(context).inviteRule,
                      style: StyleNewFactory.black15,
                      textScaleFactor: 1,
                    ),
                  ),
                ),
                onTap: () {
                  launchURL(url: "https://nxapi.cybex.io/v1/webpage/refer_rule.html");
                },
              )
            ],
            iconTheme: IconThemeData(
              color: Palette.backButtonColor, //change your color here
            ),
            centerTitle: true,
            title: Text(I18n.of(context).inviteFriend, style: StyleNewFactory.black18),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
          ),
          bottomNavigationBar: Container(
            height: ScreenUtil.getInstance().setHeight(95),
            padding: EdgeInsets.only(right: 15, left: 15, top: 9, bottom: 14),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                      offset: Offset(0, -4),
                      spreadRadius: 0,
                      blurRadius: 4)
                ],
                border: Border(
                    top: BorderSide(width: 0.5, color: Palette.appInvitationBorderColor),
                    left: BorderSide(width: 0.5, color: Palette.appInvitationBorderColor),
                    right: BorderSide(width: 0.5, color: Palette.appInvitationBorderColor))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(I18n.of(context).inviteMyPinCode, style: StyleNewFactory.golden15),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 1.5, bottom: 1.5, left: 10, right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xffFCF6EA)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              locator.get<UserManager>().user.name,
                              style: StyleNewFactory.golden15,
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                  text: locator.get<UserManager>().user.name,
                                ));
                                showThemeToast("复制成功");
                              },
                              child: Text(
                                "复制",
                                style: StyleNewFactory.golden15,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(RoutePaths.Share);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Palette.appYellowOrange,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "> 专属海报 <",
                            style: StyleNewFactory.white15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => launchURL(
                            url:
                                "https://bbb.cybex.io/?id=${locator.get<UserManager>().user.name}#/"),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Palette.appInvitationYellowColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "> 邀请链接 <",
                            style: StyleNewFactory.golden15,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          body: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              FittedBox(
                                  child: SvgPicture.asset(
                                R.resAssetsIconsInvitationBackground,
                                height: ScreenUtil.instance.setHeight(166),
                                width: ScreenUtil.screenWidthDp,
                              )),
                              FittedBox(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil.instance.setHeight(133),
                                        right: ScreenUtil.getInstance().setWidth(10),
                                        left: ScreenUtil.getInstance().setWidth(10)),
                                    child: Stack(children: [
                                      SvgPicture.asset(model.vipBackground,
                                          width: ScreenUtil.getInstance().setWidth(360),
                                          height: ScreenUtil.getInstance().setHeight(145)),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil.getInstance().setWidth(22.5),
                                              top: ScreenUtil.getInstance().setHeight(8.5)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(model.rebateUserResponse?.title ?? "--",
                                                  style: StyleNewFactory.getInvitationVipText(
                                                      color: model.vipTextColor,
                                                      fontSize: Dimen.fontSize25)),
                                              model.rebateUserResponse?.rebateRatio == null
                                                  ? Text("返佣比例：--")
                                                  : Text(
                                                      "返佣比例：${model.rebateUserResponse.rebateRatio * 100}%",
                                                      style: StyleNewFactory.getInvitationVipText(
                                                          color: model.vipTextColor,
                                                          fontSize: Dimen.fontSize14),
                                                    ),
                                              SizedBox(
                                                height: ScreenUtil.getInstance().setHeight(25.5),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      "当前有效邀请：${model.rebateUserResponse?.currentEffectiveReferral ?? "--"}",
                                                      style: StyleNewFactory.getInvitationVipText(
                                                          color: model.vipTextColor,
                                                          fontSize: Dimen.fontSize12)),
                                                  SizedBox(
                                                    width: ScreenUtil.getInstance().setWidth(40),
                                                  ),
                                                  model.rebateUserResponse?.nextLevelReq != null &&
                                                          model.rebateUserResponse.nextLevelReq ==
                                                              -1
                                                      ? Container()
                                                      : Text(
                                                          "离升级还差：${model.rebateUserResponse?.nextLevelReq ?? "--"}",
                                                          style:
                                                              StyleNewFactory.getInvitationVipText(
                                                                  color: model.vipTextColor,
                                                                  fontSize: Dimen.fontSize12),
                                                        )
                                                ],
                                              ),
                                              SizedBox(
                                                height: ScreenUtil.getInstance().setHeight(5),
                                              ),
                                              LinearPercentIndicator(
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                width: ScreenUtil.getInstance().setWidth(225),
                                                lineHeight: ScreenUtil.getInstance().setHeight(8),
                                                percent: model.percent,
                                                backgroundColor: Colors.white,
                                                progressColor: Palette.appYellowOrange,
                                              ),
                                            ],
                                          ))
                                    ])),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(8.5)),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenUtil.getInstance().setWidth(10),
                                          ScreenUtil.getInstance().setHeight(17),
                                          ScreenUtil.getInstance().setWidth(10),
                                          ScreenUtil.getInstance().setHeight(17)),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          gradient: LinearGradient(
                                              tileMode: TileMode.repeated,
                                              colors: [Color(0xffFD8448), Color(0xffFEB38E)])),
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            R.resAssetsIconsInvitationNewRebate,
                                            width: ScreenUtil.getInstance().setWidth(50),
                                            height: ScreenUtil.getInstance().setWidth(50),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: ScreenUtil.getInstance().setWidth(10)),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    model.rebateUserResponse?.latestRebate
                                                            ?.toStringAsFixed(4) ??
                                                        "--",
                                                    style: StyleNewFactory.invitationBrown22,
                                                  ),
                                                  Text(
                                                    "昨日返佣",
                                                    style: StyleNewFactory.invitationBrown13,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil.getInstance().setWidth(10),
                                ),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            ScreenUtil.getInstance().setWidth(10),
                                            ScreenUtil.getInstance().setHeight(17),
                                            ScreenUtil.getInstance().setWidth(10),
                                            ScreenUtil.getInstance().setHeight(17)),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            gradient: LinearGradient(
                                                tileMode: TileMode.repeated,
                                                colors: [
                                                  Color(0xffFAD961),
                                                  Color(0xffF9A23F),
                                                  Color(0xffFFA700)
                                                ])),
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              R.resAssetsIconsInvitationTotalRebate,
                                              width: ScreenUtil.getInstance().setWidth(50),
                                              height: ScreenUtil.getInstance().setWidth(50),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: ScreenUtil.getInstance().setWidth(10)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      model.rebateUserResponse?.totalRebate
                                                              ?.toStringAsFixed(4) ??
                                                          "--",
                                                      style: StyleNewFactory.invitationBrown22,
                                                    ),
                                                    Text(
                                                      "累积返佣",
                                                      style: StyleNewFactory.invitationBrown13,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil.getInstance().setHeight(15), left: 15, right: 15),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 18,
                                    width: 4,
                                    color: Palette.appYellowOrange,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "排行榜",
                                    style: StyleNewFactory.black18,
                                  )
                                ],
                              )),
                          Container(
                            decoration: DecorationFactory.invitationContainerShadowDecoration,
                            margin: EdgeInsets.only(
                                top: ScreenUtil.getInstance().setHeight(15), left: 15, right: 15),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil.getInstance().setHeight(15),
                                          bottom: ScreenUtil.getInstance().setHeight(10)),
                                      child: Column(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            R.resAssetsIconsIcTopSecond,
                                            width: ScreenUtil.getInstance().setWidth(40),
                                            height: ScreenUtil.getInstance().setHeight(50),
                                          ),
                                          SizedBox(height: ScreenUtil.getInstance().setHeight(5)),
                                          Text(
                                              (model.referTopList.isEmpty ||
                                                      model.referTopList.length < 2)
                                                  ? "--"
                                                  : getEllipsisName(
                                                      value: model?.referTopList[1]?.user),
                                              style: StyleNewFactory.appCellTitleLightGrey15),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              (model.referTopList.isEmpty ||
                                                      model.referTopList.length < 2)
                                                  ? "--"
                                                  : model?.referTopList[1]?.total
                                                      ?.toStringAsFixed(4),
                                              style: StyleNewFactory.appCellTitleLightGrey14)
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil.getInstance().setHeight(10),
                                          bottom: ScreenUtil.getInstance().setHeight(16)),
                                      child: Column(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            R.resAssetsIconsIcTopFirst,
                                            width: ScreenUtil.getInstance().setWidth(40),
                                            height: ScreenUtil.getInstance().setHeight(50),
                                          ),
                                          SizedBox(height: ScreenUtil.getInstance().setHeight(5)),
                                          Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : getEllipsisName(
                                                      value: model?.referTopList[0]?.user),
                                              style: StyleNewFactory.appCellTitleLightGrey15),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              model.referTopList.isEmpty
                                                  ? "--"
                                                  : model?.referTopList[0]?.total
                                                      ?.toStringAsFixed(4),
                                              style: StyleNewFactory.appCellTitleLightGrey14)
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil.getInstance().setHeight(15),
                                          bottom: ScreenUtil.getInstance().setHeight(10)),
                                      child: Column(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            R.resAssetsIconsIcTopThird,
                                            width: ScreenUtil.getInstance().setWidth(40),
                                            height: ScreenUtil.getInstance().setHeight(50),
                                          ),
                                          SizedBox(height: ScreenUtil.getInstance().setHeight(5)),
                                          Text(
                                              (model.referTopList.isEmpty ||
                                                      model.referTopList.length < 3)
                                                  ? "--"
                                                  : getEllipsisName(
                                                      value: model?.referTopList[2]?.user),
                                              style: StyleNewFactory.appCellTitleLightGrey15),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              (model.referTopList.isEmpty ||
                                                      model.referTopList.length < 3)
                                                  ? "--"
                                                  : model?.referTopList[2]?.total
                                                      ?.toStringAsFixed(4),
                                              style: StyleNewFactory.appCellTitleLightGrey14)
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil.getInstance().setHeight(15),
                                  left: 15,
                                  right: 15,
                                  bottom: ScreenUtil.getInstance().setHeight(15)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 18,
                                    width: 4,
                                    color: Palette.appYellowOrange,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "我的邀请",
                                    style: StyleNewFactory.black18,
                                  )
                                ],
                              )),
                          Container(
                            key: _listviewContainer,
                            decoration: DecorationFactory.invitationContainerShadowDecoration,
                            margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil.getInstance().setWidth(10),
                                                ScreenUtil.getInstance().setHeight(17),
                                                ScreenUtil.getInstance().setWidth(10),
                                                ScreenUtil.getInstance().setHeight(17)),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                gradient: LinearGradient(
                                                    tileMode: TileMode.repeated,
                                                    colors: [
                                                      Color(0xffFD8448),
                                                      Color(0xffFEB38E)
                                                    ])),
                                            child: Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  R.resAssetsIconsInvitationNewInvitation,
                                                  width: ScreenUtil.getInstance().setWidth(47),
                                                  height: ScreenUtil.getInstance().setWidth(47),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            ScreenUtil.getInstance().setWidth(13)),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          model.referralNumberRecent
                                                                  ?.toStringAsFixed(0) ??
                                                              "--",
                                                          style: StyleNewFactory.invitationBrown22,
                                                        ),
                                                        Text(
                                                          "昨日新增",
                                                          style: StyleNewFactory.invitationBrown13,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  ScreenUtil.getInstance().setWidth(10),
                                                  ScreenUtil.getInstance().setHeight(17),
                                                  ScreenUtil.getInstance().setWidth(10),
                                                  ScreenUtil.getInstance().setHeight(17)),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  gradient: LinearGradient(
                                                      tileMode: TileMode.repeated,
                                                      colors: [
                                                        Color(0xffFAD961),
                                                        Color(0xffF9A23F),
                                                        Color(0xffFFA700)
                                                      ])),
                                              child: Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                    R.resAssetsIconsInvitationTotalInvitation,
                                                    width: ScreenUtil.getInstance().setWidth(47),
                                                    height: ScreenUtil.getInstance().setWidth(47),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: ScreenUtil.getInstance()
                                                              .setWidth(13)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            model.referralNumber
                                                                    ?.toStringAsFixed(0) ??
                                                                "--",
                                                            style:
                                                                StyleNewFactory.invitationBrown22,
                                                          ),
                                                          Text(
                                                            "累积新增",
                                                            style:
                                                                StyleNewFactory.invitationBrown13,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil.getInstance().setHeight(15),
                                      left: ScreenUtil.getInstance().setWidth(5),
                                      right: ScreenUtil.getInstance().setWidth(5)),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Divider(
                                          height: ScreenUtil.getInstance().setHeight(0.5),
                                          color: Palette.appInvitationGreyColor,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil.getInstance().setWidth(15.5),
                                            right: ScreenUtil.getInstance().setWidth(15.5)),
                                        child:
                                            Text("邀请明细", style: StyleNewFactory.invitationGrey13),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          height: ScreenUtil.getInstance().setHeight(0.5),
                                          color: Palette.appInvitationGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                model.referralList.length == 0
                                    ? Container(
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: ScreenUtil.getInstance().setHeight(20)),
                                              child: Text(I18n.of(context).recordEmpty,
                                                  style: StyleFactory.hintStyle)),
                                        ),
                                      )
                                    : ListView.separated(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil.getInstance().setHeight(10),
                                            bottom: 20,
                                            left: ScreenUtil.getInstance().setWidth(10),
                                            right: ScreenUtil.getInstance().setWidth(10)),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return Container(height: 10);
                                        },
                                        itemCount: model.referralList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: ScreenUtil.getInstance().setWidth(
                                                      (_getSize() -
                                                              ScreenUtil.getInstance()
                                                                  .setWidth(20)) /
                                                          2),
                                                  child: Text(
                                                      getEllipsisName(
                                                          value: model.referralList[index].referral,
                                                          precision: 10),
                                                      style: StyleNewFactory.invitationGrey13),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                        DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                                            DateTime.fromMillisecondsSinceEpoch(
                                                                    model.referralList[index].ts *
                                                                        1000)
                                                                .toLocal()),
                                                        style: StyleNewFactory.invitationGrey13),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                              ],
                            ),
                          ),
                          // Container(
                          //   decoration: DecorationFactory.invitationContainerShadowDecoration,
                          //   margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          //   padding: EdgeInsets.only(bottom: 20),
                          //   child: Column(
                          //     children: <Widget>[
                          //       Container(
                          //         alignment: Alignment.center,
                          //         color: Palette.inviteDivisionHeaderColor,
                          //         height: 40,
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: <Widget>[
                          //             SvgPicture.asset(R.resAssetsIconsIcTitleLine),
                          //             Padding(
                          //               padding: EdgeInsets.only(left: 8, right: 8),
                          //               child: Text(
                          //                 I18n.of(context).inviteReward,
                          //                 style: StyleFactory.buyUpOrderInfo,
                          //               ),
                          //             ),
                          //             SvgPicture.asset(R.resAssetsIconsIcTitleLine),
                          //           ],
                          //         ),
                          //       ),
                          //       SizedBox(height: 20),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //         children: <Widget>[
                          //           Column(
                          //             children: <Widget>[
                          //               Text(I18n.of(context).inviteReward + "(USDT)",
                          //                   style: StyleFactory.dialogContentTitleStyle),
                          //               SizedBox(height: 15),
                          //               Text(
                          //                 model?.referRewardAmount?.toStringAsFixed(4),
                          //                 style: StyleFactory.inviteAmountStyle,
                          //               ),
                          //             ],
                          //           ),
                          //           Column(
                          //             children: <Widget>[
                          //               Text(
                          //                 I18n.of(context).inviteRecommendSuc,
                          //                 style: StyleFactory.dialogContentTitleStyle,
                          //               ),
                          //               SizedBox(height: 15),
                          //               Row(
                          //                 children: <Widget>[
                          //                   Text(
                          //                     model.referralNumber.toString(),
                          //                     style: StyleFactory.inviteAmountStyle,
                          //                   ),
                          //                   SizedBox(
                          //                     width: 5,
                          //                   ),
                          //                   Text("人", style: StyleFactory.buyUpCellLabel)
                          //                 ],
                          //               )
                          //             ],
                          //           )
                          //         ],
                          //       ),
                          //       SizedBox(height: 15),
                          //       // 我的推荐码 暂时隐藏
                          //       // Row(
                          //       //   mainAxisAlignment:
                          //       //       MainAxisAlignment.spaceAround,
                          //       //   children: <Widget>[
                          //       //     Text(I18n.of(context).inviteMyPinCode,
                          //       //         style: StyleFactory.subTitleStyle),
                          //       //     Row(
                          //       //       children: <Widget>[
                          //       //         Text(
                          //       //           locator
                          //       //               .get<UserManager>()
                          //       //               .user
                          //       //               .name,
                          //       //           style: StyleFactory.subTitleStyle,
                          //       //         ),
                          //       //         GestureDetector(
                          //       //           onTap: () {
                          //       //             Clipboard.setData(ClipboardData(
                          //       //                 text: locator
                          //       //                     .get<UserManager>()
                          //       //                     .user
                          //       //                     .name));
                          //       //             showNotification(
                          //       //                 context, false, "复制成功");
                          //       //           },
                          //       //           child: SvgPicture.asset(
                          //       //               R.resAssetsIconsContentCopy),
                          //       //         ),
                          //       //       ],
                          //       //     )
                          //       //   ],
                          //       // ),
                          //       // SizedBox(
                          //       //   height: 10,
                          //       // ),
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //         children: <Widget>[
                          //           Text(I18n.of(context).inviteMyRecommender,
                          //               style: StyleFactory.subTitleStyle),
                          //           model.referrer != null
                          //               ? Text(
                          //                   model.referrer,
                          //                   style: StyleFactory.subTitleStyle,
                          //                 )
                          //               : WidgetFactory.invitePeopleButton(onPressed: () {
                          //                   TextEditingController textController =
                          //                       TextEditingController();
                          //                   TextEditingController passwordController =
                          //                       TextEditingController();
                          //                   showDialog(
                          //                       context: context,
                          //                       builder: (context) {
                          //                         return DialogFactory.addRefererDialog(context,
                          //                             controller: textController,
                          //                             controllerForPassword: passwordController);
                          //                       }).then((value) {
                          //                     if (value[0]) {
                          //                       callRegister(context, model, value[1]);
                          //                     }
                          //                   });
                          //                 })
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   key: _listviewContainer,
                          //   decoration: DecorationFactory.invitationContainerShadowDecoration,
                          //   margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                          //   child: Column(
                          //     children: <Widget>[
                          //       Container(
                          //         alignment: Alignment.center,
                          //         color: Palette.inviteDivisionHeaderColor,
                          //         height: 40,
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: <Widget>[
                          //             SvgPicture.asset(R.resAssetsIconsIcTitleLine),
                          //             Padding(
                          //               padding: EdgeInsets.only(left: 8, right: 8),
                          //               child: Text(
                          //                 I18n.of(context).inviteRecommendation,
                          //                 style: StyleFactory.buyUpOrderInfo,
                          //               ),
                          //             ),
                          //             SvgPicture.asset(R.resAssetsIconsIcTitleLine),
                          //           ],
                          //         ),
                          //       ),
                          //       ListView.separated(
                          //           padding:
                          //               EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                          //           shrinkWrap: true,
                          //           separatorBuilder: (context, index) {
                          //             return Container(height: 10);
                          //           },
                          //           itemCount: model.referralList.length,
                          //           itemBuilder: (context, index) {
                          //             return Container(
                          //               child: Row(
                          //                 children: <Widget>[
                          //                   Container(
                          //                     width: (_getSize() - 20) / 2,
                          //                     child: Text(
                          //                         getEllipsisName(
                          //                             value: model.referralList[index].referral,
                          //                             precision: 10),
                          //                         style: StyleFactory.dialogContentStyle),
                          //                   ),
                          //                   Expanded(
                          //                     child: Text(
                          //                         DateFormat("yyyy-MM-dd HH:mm").format(
                          //                             DateTime.fromMillisecondsSinceEpoch(
                          //                                 model.referralList[index].ts * 1000)),
                          //                         style: StyleFactory.dialogContentStyle),
                          //                   )
                          //                 ],
                          //               ),
                          //             );
                          //           }),
                          //     ],
                          //   ),
                          // )
                        ],
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

  double _getSize() {
    final RenderBox renderBox = _listviewContainer.currentContext.findRenderObject();
    return renderBox.size.width;
  }

  callRegister(BuildContext context, InviteViewModel model, String referer) async {
    showLoading(context);
    RegisterRefResponseModel registerRefResponseModel = await model.postRefer(referrer: referer);

    if (registerRefResponseModel == null) {
      Navigator.of(context).pop();
      showNotification(
        context,
        true,
        I18n.of(context).failToast,
      );
    } else {
      if (!registerRefResponseModel.success) {
        Navigator.of(context).pop();
        showNotification(
          context,
          true,
          registerRefResponseModel.reason,
        );
      } else {
        Navigator.of(context).pop();
        model.getRefer();
        showNotification(
          context,
          false,
          I18n.of(context).successToast,
        );
      }
    }
  }
}
