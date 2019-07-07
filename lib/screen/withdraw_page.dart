import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/withdraw_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
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
  WithdrawViewModel withdrawViewModel;

  @override
  void initState() {
    _amountFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<WithdrawViewModel>(
      model: withdrawViewModel = WithdrawViewModel(
          api: locator.get(), refm: locator.get(), um: locator.get()),
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
      },
      builder: (context, model, widget) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Palette.backButtonColor, //change your color here
              ),
              centerTitle: true,
              title: Text(I18n.of(context).withdraw, style: StyleFactory.title),
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
                      Text("${model.withdrawForm.balance.quantity} USDT",
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
                  TextFormField(
                    controller: _addressEditController,
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
                              controller: _amountController,
                              focusNode: _amountFocusNode,
                              decoration: InputDecoration(
                                  hintText: "请输入最小提现数量",
                                  hintStyle: StyleFactory.hintStyle,
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            child: Text("全部",
                                style: StyleFactory.errorMessageText),
                            onTap: () {
                              setState(() {
                                _amountController.text = model
                                    .withdrawForm.balance.quantity
                                    .toStringAsFixed(4);
                              });
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
                      Text("提现手续费", style: StyleFactory.transferStyleTitle),
                      Text("0.0001 CYB",
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
                    child: Text(
                        "您将提出您的 ETH 到外部地址。瑶池（Jadepool）作为Cybex推荐的网关将为您提供这一服务。网关服务需要收取一定的服务手续费，将以ETH支付，从您拟提取的金额中扣除提现过程中还将执行一次Cybex内盘转账，该部分手续费您可选择使用CYB或ETH支付 请务必确认您的提币地址正确，一旦填写错误，您的资产将丢失 所有出入金到账需要一定时限，请耐心等待 提币操作请使用您的个人钱包地址。提币到合约地址、交易所地址、ICO项目地址可能会发生合约执行失败，将导致转账失败，资产将退回到您的Cybex账户，处理时间较长，请您谅解",
                        style: StyleFactory.subTitleStyle),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("到账数量", style: StyleFactory.transferStyleTitle),
                      Text("${model.withdrawForm.totalAmount.amount} USDT",
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
                        color: Palette.redOrange,
                        onPressed: () async {
                          model.withdrawForm.address =
                              _addressEditController.text;
                          if (locator.get<UserManager>().user.isLocked) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogFactory.sellOrderDialog(context);
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
            ))));
      },
    );
  }

  callPostWithdraw(WithdrawViewModel model) async {
    try {
      showLoading(context);
      await model.postWithdraw();
      Navigator.of(context).pop();
      showToast(context, false, I18n.of(context).successToast);
      model.getCurrentBalance();
    } catch (error) {
      Navigator.of(context).pop();
      showToast(context, true, I18n.of(context).failToast);
    }
  }
}
