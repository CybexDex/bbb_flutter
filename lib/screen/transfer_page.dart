import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/transfer_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class TransferPage extends StatefulWidget {
  TransferPage({Key key}) : super(key: key);

  @override
  State createState() => _TransferState();
}

class _TransferState extends State<TransferPage> {
  TextEditingController _amountEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseWidget<TransferViewModel>(
      model: TransferViewModel(
          api: locator.get(), refm: locator.get(), um: locator.get()),
      onModelReady: (model) {
        model.initForm();
      },
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Palette.backButtonColor, //change your color here
              ),
              centerTitle: true,
              title: Text(I18n.of(context).transfer, style: StyleFactory.title),
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          I18n.of(context).assetCat,
                          style: StyleFactory.larSubtitle,
                        ),
                        Text("USDT", style: StyleFactory.larSubtitle),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(color: Palette.separatorColor),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("从",
                                        style: StyleFactory.transferStyleTitle),
                                    SizedBox(width: 36),
                                    Text(model.transferForm.fromBBBToCybex
                                        ? "BBB账户"
                                        : "CYBEX账户"),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color: Palette.redOrange,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("转至",
                                        style: StyleFactory.transferStyleTitle),
                                    SizedBox(width: 36),
                                    Text(model.transferForm.fromBBBToCybex
                                        ? "CYBEX账户"
                                        : "BBB账户"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Image.asset(R.resAssetsIconsIcSwitch),
                            onTap: () {
                              model.switchAccountSide();
                            },
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Palette.separatorColor,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("数量"),
                        Text(
                            "可划转数量: ${model.transferForm.balance.quantity} ${model.transferForm.balance.assetName}"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: _amountEditingController,
                                decoration: InputDecoration(
                                    hintText: "请输入划转数量",
                                    hintStyle: StyleFactory.hintStyle,
                                    border: InputBorder.none),
                              ),
                            ),
                            GestureDetector(
                              child: Text("全部划转",
                                  style: StyleFactory.errorMessageText),
                              onTap: () {},
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Palette.separatorColor,
                                      width: 0.8))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: false,
                          child: Row(
                            children: <Widget>[
                              Image.asset(R.resAssetsIconsIcWarn),
                              Text("CYBEX账户余额不足/BBB账户余额不足",
                                  style: StyleFactory.errorMessageText)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("手续费", style: StyleFactory.transferStyleTitle),
                            Text("0.0001 CYB",
                                style: StyleFactory.transferStyleTitle),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ButtonTheme(
                          minWidth: double.infinity,
                          height: 44,
                          child: WidgetFactory.button(
                              data: "立即划转",
                              color: Palette.redOrange,
                              onPressed: () async {
                                model.transferForm.totalAmount = Asset(
                                    amount: double.parse(
                                        _amountEditingController.text),
                                    symbol:
                                        model.transferForm.balance.assetName);
                                if (locator.get<UserManager>().user.isLocked) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DialogFactory.sellOrderDialog(
                                            context);
                                      }).then((value) async {
                                    if (value) {
                                      callPostWithdraw(model);
                                    }
                                  });
                                } else {
                                  callPostWithdraw(model);
                                }
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              )),
            ));
      },
    );
  }

  callPostWithdraw(TransferViewModel model) async {
    try {
      showLoading(context);
      await model.postTransfer();
      Navigator.of(context).pop();
      showToast(context, false, I18n.of(context).successToast);
      model.getCurrentBalance();
    } catch (error) {
      Navigator.of(context).pop();
      showToast(context, true, I18n.of(context).failToast);
    }
  }
}
