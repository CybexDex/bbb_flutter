import 'package:bbb_flutter/helper/decimal_util.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/transfer_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: BaseWidget<TransferViewModel>(
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
                title:
                    Text(I18n.of(context).transfer, style: StyleFactory.title),
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
                          Text(AssetName.USDT, style: StyleFactory.larSubtitle),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(color: Palette.separatorColor),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 150,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(I18n.of(context).transferFrom,
                                          style:
                                              StyleFactory.transferStyleTitle),
                                      Text(model.transferForm.fromBBBToCybex
                                          ? I18n.of(context).transferBbbAccount
                                          : I18n.of(context)
                                              .transferCybexAccount),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(I18n.of(context).transferTo,
                                          style:
                                              StyleFactory.transferStyleTitle),
                                      Text(model.transferForm.fromBBBToCybex
                                          ? I18n.of(context)
                                              .transferCybexAccount
                                          : I18n.of(context)
                                              .transferBbbAccount),
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
                          Text(I18n.of(context).transferAmount),
                          Text(model.transferForm.balance != null
                              ? "${I18n.of(context).transferAvailableAmount}: ${floor(model.transferForm.balance.quantity, 4)} USDT"
                              : "${I18n.of(context).transferAvailableAmount}: --"),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                                  controller: _amountEditingController,
                                  onChanged: (value) {
                                    if (value.isNotEmpty &&
                                        double.tryParse(value) != null) {
                                      model.setTotalAmount(
                                          value: double.parse(value));
                                    } else {
                                      model.setTotalAmount(value: null);
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText:
                                          I18n.of(context).transferAmountHint,
                                      hintStyle: StyleFactory.hintStyle,
                                      border: InputBorder.none),
                                ),
                              ),
                              GestureDetector(
                                child: Text(I18n.of(context).transferAll,
                                    style: StyleFactory.errorMessageText),
                                onTap: () {
                                  model.setTotalAmount(
                                      value: double.parse(floor(
                                          model.transferForm.balance.quantity,
                                          4)));
                                  _amountEditingController.text = floor(
                                      model.transferForm.balance.quantity, 4);
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
                          SizedBox(
                            height: 15,
                          ),
                          Offstage(
                            offstage: model.isButtonAvailable ||
                                model.transferForm.totalAmount.amount == null,
                            child: Row(
                              children: <Widget>[
                                Image.asset(R.resAssetsIconsIcWarn),
                                Builder(builder: (context) {
                                  if (model.transferForm.totalAmount.amount !=
                                          null &&
                                      model.transferForm.totalAmount.amount <=
                                          0) {
                                    return Text(
                                        I18n.of(context)
                                            .orderFormInputPositiveNumberError,
                                        style: StyleFactory.errorMessageText);
                                  } else if (model
                                          .transferForm.totalAmount.symbol ==
                                      AssetName.USDT) {
                                    return Text(
                                        I18n.of(context)
                                            .transferErrorMessageCybNotEnough,
                                        style: StyleFactory.errorMessageText);
                                  } else if (model
                                          .transferForm.totalAmount.symbol ==
                                      AssetName.NXUSDT) {
                                    return Text(
                                        I18n.of(context)
                                            .transferErrorMessageBbbNotEnough,
                                        style: StyleFactory.errorMessageText);
                                  }
                                  return Container();
                                })
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(I18n.of(context).fee,
                                  style: StyleFactory.transferStyleTitle),
                              Text("0.01 CYB",
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
                                data: I18n.of(context).transferNow,
                                color: model.isButtonAvailable
                                    ? Palette.redOrange
                                    : Palette.subTitleColor,
                                onPressed: model.isButtonAvailable
                                    ? () async {
                                        if (model.transferForm.cybBalance
                                                .quantity <
                                            (AssetDef.CYB_TRANSFER.amount /
                                                100000)) {
                                          showToast(context, true,
                                              I18n.of(context).noFeeError);
                                        } else {
                                          TextEditingController controller =
                                              TextEditingController();
                                          if (locator
                                              .get<UserManager>()
                                              .user
                                              .isLocked) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return DialogFactory
                                                      .unlockDialog(context,
                                                          controller:
                                                              controller);
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
                    ],
                  ),
                )),
              ));
        },
      ),
    );
  }

  callPostWithdraw(TransferViewModel model) async {
    showLoading(context);
    try {
      PostOrderResponseModel responseModel = await model.postTransfer();
      Navigator.of(context).pop();
      if (responseModel.status == "Failed") {
        showToast(context, true, responseModel.reason);
      } else {
        showToast(context, false, I18n.of(context).successToast);
        model.getCurrentBalance();
      }
    } catch (error) {
      Navigator.of(context).pop();
      showToast(context, true, I18n.of(context).failToast);
    }
  }
}
