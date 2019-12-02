import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

import 'istep.dart';

class ReviseWidget extends StatefulWidget {
  final OrderResponseModel _order;
  final PnlViewModel model;
  final TextEditingController _takeProfitController;
  final TextEditingController _takeProfitPxController;
  final TextEditingController _cutLossController;
  final TextEditingController _cutLossPxController;

  ReviseWidget(
      {Key key,
      OrderResponseModel order,
      PnlViewModel pnlViewModel,
      TextEditingController takeProfitController,
      TextEditingController takeProfitPxController,
      TextEditingController cutLossController,
      TextEditingController cutLossPxController,
      bool isPx})
      : _order = order,
        model = pnlViewModel,
        _takeProfitController = takeProfitController,
        _takeProfitPxController = takeProfitPxController,
        _cutLossController = cutLossController,
        _cutLossPxController = cutLossPxController,
        super(key: key);

  @override
  ReviseState createState() => ReviseState();
}

class ReviseState extends State<ReviseWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "${I18n.of(context).takeProfit}(%)",
              style: StyleFactory.subTitleStyle,
            ),
            SizedBox(
                width: 250,
                height: 40,
                child: Material(
                  child: IStep(
                    text: widget._takeProfitController,
                    plusOnTap: () {
                      widget.model.increaseTakeProfit(order: widget._order);
                      widget.model.setTakeProfitInputCorrectness(true);
                      widget._takeProfitController.text =
                          widget.model.takeProfit.toStringAsFixed(0);
                      widget._takeProfitPxController.text =
                          widget.model.takeProfitPx.toStringAsFixed(0);
                    },
                    minusOnTap: () {
                      widget.model.decreaseTakeProfit(order: widget._order);
                      widget.model.setTakeProfitInputCorrectness(true);
                      widget._takeProfitController.text =
                          widget.model.takeProfit.toStringAsFixed(0);
                      widget._takeProfitPxController.text =
                          widget.model.takeProfitPx.toStringAsFixed(0);
                    },
                    onChange: (value) {
                      if (value.isNotEmpty &&
                          (double.tryParse(value) == null ||
                              double.tryParse(value) < 0)) {
                        widget.model.setTakeProfitInputCorrectness(false);
                      } else {
                        widget.model.setTakeProfitInputCorrectness(true);
                        widget.model.changeTakeProfit(
                            profit: value.isEmpty ? null : double.parse(value),
                            order: widget._order);
                        widget._takeProfitPxController.text =
                            widget.model.takeProfitPx == 0
                                ? I18n.of(context).stepWidgetNotSetHint
                                : widget.model.takeProfitPx.toStringAsFixed(0);
                      }
                    },
                  ),
                )),
            GestureDetector(
              onTap: () {
                widget.model.setTakeProfitInputCorrectness(true);
                widget.model
                    .changeTakeProfit(profit: null, order: widget._order);
                widget._takeProfitController.text =
                    I18n.of(context).stepWidgetNotSetHint;
                widget._takeProfitPxController.text =
                    I18n.of(context).stepWidgetNotSetHint;
              },
              child: Text(
                I18n.of(context).orderFormReset,
                style: StyleFactory.subTitleStyle,
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: Text(
        //     "≈ ${widget.model.takeProfitPx.toStringAsFixed(4)}",
        //     style: StyleFactory.cellDescLabel,
        //   ),
        // ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "${I18n.of(context).cutLoss}(%)",
                  style: StyleFactory.subTitleStyle,
                ),
              ],
            ),
            SizedBox(
                width: 250,
                height: 40,
                child: Material(
                  child: IStep(
                    text: widget._cutLossController,
                    plusOnTap: () {
                      widget.model.increaseCutLoss(order: widget._order);
                      widget.model.setCutLossInputCorectness(true);
                      widget._cutLossController.text =
                          widget.model.cutLoss.toStringAsFixed(0);
                      widget._cutLossPxController.text =
                          widget.model.cutLossPx.toStringAsFixed(0);
                    },
                    minusOnTap: () {
                      widget.model.decreaseCutLoss(order: widget._order);
                      widget.model.setCutLossInputCorectness(true);
                      widget._cutLossController.text =
                          widget.model.cutLoss.toStringAsFixed(0);
                      widget._cutLossPxController.text =
                          widget.model.cutLossPx.toStringAsFixed(0);
                    },
                    onChange: (value) {
                      if (value.isNotEmpty &&
                          (double.tryParse(value) == null ||
                              double.tryParse(value) < 0)) {
                        widget.model.setCutLossInputCorectness(false);
                      } else {
                        widget.model.setCutLossInputCorectness(true);
                        widget.model.changeCutLoss(
                            cutLoss: value.isEmpty
                                ? null
                                : double.parse(value) > 100
                                    ? 100
                                    : double.parse(value),
                            order: widget._order);
                        if (value.isNotEmpty && double.parse(value) > 100) {
                          widget._cutLossController.text = "100";
                        }
                        widget._cutLossPxController.text =
                            widget.model.cutLossPx.toStringAsFixed(0);
                      }
                    },
                  ),
                )),
            GestureDetector(
              onTap: () {
                widget.model.setCutLossInputCorectness(true);
                widget.model.changeCutLoss(cutLoss: 100, order: widget._order);
                widget._cutLossController.text = "100";
                widget._cutLossPxController.text =
                    widget.model.cutLossPx.toStringAsFixed(0);
              },
              child: Text(
                I18n.of(context).orderFormReset,
                style: StyleFactory.subTitleStyle,
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: Text(
        //     "≈ ${widget.model.cutLossPx.toStringAsFixed(4)}",
        //     style: StyleFactory.cellDescLabel,
        //   ),
        // ),
        Offstage(
            offstage: widget.model.isCutLossInputCorrect &&
                widget.model.isTakeProfitInputCorrect &&
                widget.model.isCutLossCorrect,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10),
              child: Builder(
                builder: (context) {
                  if (!widget.model.isCutLossInputCorrect ||
                      !widget.model.isTakeProfitInputCorrect) {
                    return Text(
                        I18n.of(context).orderFormInputPositiveNumberError,
                        style: StyleFactory.smallButtonTitleStyle);
                  } else if (!widget.model.isCutLossCorrect &&
                      widget._order.boughtPx > widget._order.forceClosePx) {
                    return Text(
                      I18n.of(context).orderFormBuyUpCutlossLowerStriklevel,
                      style: StyleFactory.smallButtonTitleStyle,
                    );
                  } else if (!widget.model.isCutLossCorrect &&
                      widget._order.boughtPx < widget._order.forceClosePx) {
                    return Text(
                      I18n.of(context).orderFormBuyDownCutlossHigherStriklevel,
                      style: StyleFactory.smallButtonTitleStyle,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
