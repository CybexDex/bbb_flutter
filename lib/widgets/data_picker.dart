import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/coupon_response.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/cupertino.dart';

class DataPickerWidget extends StatefulWidget {
  final dynamic _model;
  final bool _isCoupon;
  DataPickerWidget({Key key, dynamic model, bool isCoupon})
      : _model = model,
        _isCoupon = isCoupon,
        super(key: key);

  @override
  DataPickerState createState() {
    return DataPickerState();
  }
}

class DataPickerState extends State<DataPickerWidget> {
  Contract selectedContract;
  Coupon selectedCoupon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            elevation: 0,
            leading: Align(
              alignment: Alignment.center,
              child: Text(
                I18n.of(context).dialogCancelButton,
                style: StyleNewFactory.grey15,
              ),
            ),
            backgroundColor: Palette.seperateOrBackgroundGreyColor,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  if (widget._isCoupon) {
                    if (selectedCoupon != null) {
                      widget._model.onChnageCouponDropdownSelection(selectedCoupon);
                    }
                  } else {
                    if (selectedContract != null) {
                      widget._model.onChnageDropdownSelection(selectedContract);
                    }
                  }
                  Navigator.of(context).maybePop();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    I18n.of(context).confirm,
                    style: StyleNewFactory.yellowOrange15,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            !widget._isCoupon
                ? Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            I18n.of(context).forceClosePrice,
                            style: StyleNewFactory.black15,
                          ),
                          Text(I18n.of(context).actLevel, style: StyleNewFactory.black15)
                        ],
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              flex: 6,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                squeeze: 1.2,
                diameterRatio: 1.1,
                children: widget._isCoupon
                    ? widget._model.couponList
                    : widget._model.orderForm.pickerItems,
                itemExtent: 36,
                onSelectedItemChanged: (int index) {
                  if (widget._isCoupon) {
                    selectedCoupon = widget._model.couponListData[index];
                  } else {
                    selectedContract = widget._model.contractIds[index];
                  }
                },
              ),
            ),
          ],
        ));
  }
}
