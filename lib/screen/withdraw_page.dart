import 'package:bbb_flutter/helper/decimal_util.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/withdraw_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class WithdrawPage extends StatefulWidget {
  WithdrawPage({Key key}) : super(key: key);

  @override
  State createState() => _WithdrawState();
}

class _WithdrawState extends State<WithdrawPage> {
  TextEditingController _addressEditController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  FocusNode _amountFocusNode;
  FocusNode _addressFocusNode;
  WithdrawViewModel withdrawViewModel;

  @override
  void initState() {
    _amountFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: BaseWidget<WithdrawViewModel>(
        model: withdrawViewModel = WithdrawViewModel(
            api: locator.get(),
            refm: locator.get(),
            um: locator.get(),
            gatewayApi: locator.get()),
        onModelReady: (model) {
          model.initForm();
          _amountController.addListener(() {
            if (_amountController.text.length > 0) {
              Asset asset = Asset(
                  amount: double.parse(_amountController.text), symbol: "USDT");
              model.setTotalAmount(asset);
            } else {
              model.setTotalAmount(Asset(amount: 0, symbol: "USDT"));
            }
          });
          _addressFocusNode.addListener(() {
            if (!_addressFocusNode.hasFocus) {
              model.verifyAddress(address: _addressEditController.text);
            }
          });
        },
        builder: (context, model, widget) {
          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Palette.backButtonColor, //change your color here
                ),
                centerTitle: true,
                title:
                    Text(I18n.of(context).withdraw, style: StyleFactory.title),
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
                          I18n.of(context).balanceAvailable,
                          style: StyleFactory.larSubtitle,
                        ),
                        Text(
                            model.withdrawForm.balance != null
                                ? "${floor(model.withdrawForm.balance.quantity, 4)} USDT"
                                : "-- USDT",
                            style: StyleFactory.larSubtitle),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(color: Palette.separatorColor),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("提现地址"),
                    ),
                    TextField(
                      focusNode: _addressFocusNode,
                      controller: _addressEditController,
                      onChanged: (value) {
                        model.verifyAddress(address: value);
                      },
                      decoration: InputDecoration(
                          hintText: "输入或长按粘贴地址",
                          hintStyle: StyleFactory.hintStyle,
                          border: InputBorder.none),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Palette.separatorColor, width: 0.8))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("数量"),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true, signed: false),
                                controller: _amountController,
                                focusNode: _amountFocusNode,
                                decoration: InputDecoration(
                                    hintText:
                                        "请输入最小提现数量 ${model.gatewayAssetResponseModel.minWithdraw}",
                                    hintStyle: StyleFactory.hintStyle,
                                    border: InputBorder.none),
                              ),
                            ),
                            GestureDetector(
                              child: Text("全部",
                                  style: StyleFactory.errorMessageText),
                              onTap: () {
                                _amountController.text = floor(
                                    model.withdrawForm.balance.quantity, 4);
                              },
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
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Offstage(
                      offstage: (model.isHide ||
                          (_amountController.text.isEmpty &&
                              (_addressEditController.text.isEmpty ||
                                  (model.verifyAddressResponseModel != null &&
                                      model
                                          .verifyAddressResponseModel.valid)))),
                      child: Row(
                        children: <Widget>[
                          Image.asset(R.resAssetsIconsIcWarn),
                          Builder(
                            builder: (context) {
                              if (model.verifyAddressResponseModel != null &&
                                  !model.verifyAddressResponseModel.valid) {
                                return Text("地址不正确",
                                    style: StyleFactory.errorMessageText);
                              } else if (model.withdrawForm.totalAmount.amount >
                                  model.withdrawForm.balance.quantity) {
                                return Text("余额不足",
                                    style: StyleFactory.errorMessageText);
                              } else if (model.withdrawForm.totalAmount.amount <
                                  model.gatewayAssetResponseModel.minWithdraw) {
                                return Text("提现小于最小提现额",
                                    style: StyleFactory.errorMessageText);
                              }
                              return Container();
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("提现手续费", style: StyleFactory.transferStyleTitle),
                        Text(
                            "${model.gatewayAssetResponseModel.withdrawFee} USDT",
                            style: StyleFactory.transferStyleTitle),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Palette.veryLightPink,
                        borderRadius: BorderRadius.all(Radius.circular(4.0) //
                            ),
                      ),
                      child: Text(I18n.of(context).withdrawParagraph,
                          style: StyleFactory.subTitleStyle),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("到账数量", style: StyleFactory.transferStyleTitle),
                        model.withdrawForm.totalAmount.amount == 0
                            ? Text(
                                "${model.withdrawForm.totalAmount.amount.toStringAsFixed(4)} USDT",
                                style: StyleFactory.transferStyleTitle)
                            : Text(
                                "${floor((model.withdrawForm.totalAmount.amount - double.parse(model.gatewayAssetResponseModel.withdrawFee)), 4)} USDT",
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
                          data: "提现",
                          color: model.isHide &&
                                  model.verifyAddressResponseModel != null
                              ? Palette.redOrange
                              : Palette.subTitleColor,
                          onPressed: model.isHide &&
                                  model.verifyAddressResponseModel != null
                              ? () async {
                                  if (model.withdrawForm.cybBalance.quantity <
                                      (AssetDef.CYB_TRANSFER.amount / 100000)) {
                                    showNotification(context, true,
                                        I18n.of(context).noFeeError);
                                  } else {
                                    model.withdrawForm.address =
                                        _addressEditController.text;
                                    TextEditingController controller =
                                        TextEditingController();

                                    if (locator
                                        .get<UserManager>()
                                        .user
                                        .isLocked) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DialogFactory.unlockDialog(
                                                context,
                                                controller: controller);
                                          }).then((value) async {
                                        if (value) {
                                          callPostWithdraw(model);
                                        }
                                      });
                                    } else {
                                      callPostWithdraw(model);
                                    }
                                  }
                                }
                              : () {}),
                    )
                  ],
                ),
              ))));
        },
      ),
    );
  }

  callPostWithdraw(WithdrawViewModel model) async {
    showLoading(context);
    try {
      PostOrderResponseModel responseModel = await model.postWithdraw();
      Navigator.of(context).pop();
      if (responseModel.status == "Failed") {
        showNotification(context, true, responseModel.errorMesage);
      } else {
        showNotification(context, false, I18n.of(context).successToast);
      }
    } catch (error) {
      Navigator.of(context).pop();
      showNotification(context, true, I18n.of(context).failToast);
    }
  }
}
