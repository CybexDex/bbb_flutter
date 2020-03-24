import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

import 'istep.dart';

class RevisePxWidget extends StatefulWidget {
  final OrderResponseModel _order;
  final PnlViewModel model;
  final TextEditingController _takeProfitPxController;
  final TextEditingController _takeProfitController;
  final TextEditingController _cutLossPxController;
  final TextEditingController _cutLossController;

  RevisePxWidget(
      {Key key,
      OrderResponseModel order,
      PnlViewModel pnlViewModel,
      TextEditingController takeProfitPxController,
      TextEditingController takeProfitController,
      TextEditingController cutLossPxController,
      TextEditingController cutLossController,
      bool isPx})
      : _order = order,
        model = pnlViewModel,
        _takeProfitPxController = takeProfitPxController,
        _cutLossPxController = cutLossPxController,
        _takeProfitController = takeProfitController,
        _cutLossController = cutLossController,
        super(key: key);

  @override
  RevisePxState createState() => RevisePxState();
}

class RevisePxState extends State<RevisePxWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "${I18n.of(context).takeProfit}",
              style: StyleFactory.subTitleStyle,
            ),
            SizedBox(
                width: 250,
                height: 40,
                child: Material(
                  child: IStep(
                    isPrice: true,
                    text: widget._takeProfitPxController,
                    plusOnTap: () {
                      widget.model.increaseTakeProfitPx(order: widget._order);
                      widget.model.setTakeProfitInputCorrectness(true);
                      widget._takeProfitPxController.text =
                          widget.model.takeProfitPx.toStringAsFixed(4);
                      widget._takeProfitController.text =
                          widget.model.takeProfit.toStringAsFixed(0);
                    },
                    minusOnTap: () {
                      widget.model.decreaseTakeProfitPx(order: widget._order);
                      widget.model.setTakeProfitInputCorrectness(true);
                      widget._takeProfitPxController.text =
                          widget.model.takeProfitPx == 0
                              ? I18n.of(context).stepWidgetNotSetHint
                              : widget.model.takeProfitPx.toStringAsFixed(4);
                      widget._takeProfitController.text =
                          widget.model.takeProfit == null
                              ? I18n.of(context).stepWidgetNotSetHint
                              : widget.model.takeProfit.toStringAsFixed(0);
                    },
                    onChange: (value) {
                      if (value.isNotEmpty &&
                          (double.tryParse(value) == null ||
                              double.tryParse(value) < 0)) {
                        widget.model.setTakeProfitInputCorrectness(false);
                      } else {
                        widget.model.setTakeProfitInputCorrectness(true);
                        widget.model.changeTakeProfitPx(
                            profitPrice:
                                value.isEmpty ? null : double.parse(value),
                            order: widget._order);
                        widget._takeProfitController.text =
                            widget.model.takeProfit == null
                                ? I18n.of(context).stepWidgetNotSetHint
                                : widget.model.takeProfit.toStringAsFixed(0);
                      }
                    },
                  ),
                )),
            GestureDetector(
              onTap: () {
                widget.model.setTakeProfitInputCorrectness(true);
                widget.model
                    .changeTakeProfitPx(profitPrice: 0, order: widget._order);
                widget._takeProfitPxController.text =
                    I18n.of(context).stepWidgetNotSetHint;
                widget._takeProfitController.text =
                    widget.model.takeProfit == null
                        ? I18n.of(context).stepWidgetNotSetHint
                        : widget.model.takeProfit.toStringAsFixed(0);
              },
              child: Text(
                I18n.of(context).orderFormReset,
                style: StyleFactory.subTitleStyle,
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        // SizedBox(
        //   height: 5,
        // ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: Text(
        //     "≈ ${widget.model.takeProfit?.toStringAsFixed(4)}",
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
                  "${I18n.of(context).cutLoss}",
                  style: StyleFactory.subTitleStyle,
                ),
              ],
            ),
            SizedBox(
                width: 250,
                height: 40,
                child: Material(
                  child: IStep(
                    isPrice: true,
                    text: widget._cutLossPxController,
                    plusOnTap: () {
                      widget.model.increaseCutLossPx(order: widget._order);
                      widget.model.setCutLossInputCorectness(true);
                      widget._cutLossPxController.text =
                          widget.model.cutLossPx.toStringAsFixed(4);
                      widget._cutLossController.text =
                          widget.model.cutLoss.toStringAsFixed(0);
                    },
                    minusOnTap: () {
                      widget.model.decreaseCutLossPx(order: widget._order);
                      widget.model.setCutLossInputCorectness(true);
                      widget._cutLossPxController.text =
                          widget.model.cutLossPx.toStringAsFixed(4);
                      widget._cutLossController.text =
                          widget.model.cutLoss.toStringAsFixed(0);
                    },
                    onChange: (value) {
                      if (value.isNotEmpty &&
                          (double.tryParse(value) == null ||
                              double.tryParse(value) < 0)) {
                        widget.model.setCutLossInputCorectness(false);
                      } else {
                        widget.model.setCutLossInputCorectness(true);
                        widget.model.changeCutLossPx(
                            cutLossPx: value.isEmpty
                                ? null
                                // : double.parse(value) > widget._order.cutLossPx
                                //     ? widget._order.cutLossPx
                                : double.parse(value),
                            order: widget._order);
                        // if (double.parse(value) > widget._order.cutLossPx) {

                        // }
                        widget._cutLossController.text =
                            widget.model.cutLoss == null
                                ? "100"
                                : widget.model.cutLoss.toStringAsFixed(0);
                      }
                    },
                  ),
                )),
            GestureDetector(
              onTap: () {
                widget.model.setCutLossInputCorectness(true);
                widget.model.changeCutLossPx(
                    cutLossPx: widget._order.forceClosePx,
                    order: widget._order);
                widget._cutLossPxController.text =
                    widget.model.cutLossPx.toStringAsFixed(4);
                widget._cutLossController.text = widget.model.cutLoss == null
                    ? "100"
                    : widget.model.cutLoss.toStringAsFixed(0);
              },
              child: Text(
                I18n.of(context).orderFormReset,
                style: StyleFactory.subTitleStyle,
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        // SizedBox(
        //   height: 5,
        // ),
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
