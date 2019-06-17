import 'package:bbb_flutter/blocs/order_form_bloc.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'istep.dart';

class OrderFormWidget extends StatefulWidget {
  OrderFormWidget({Key key}) : super(key: key);

  _OrderFormWidgetState createState() => _OrderFormWidgetState();
}

class _OrderFormWidgetState extends State<OrderFormWidget> {
  @override
  Widget build(BuildContext context) {
    final OrderFormBloc bloc = BlocProvider.of<OrderFormBloc>(context);

    return StreamBuilder(
      stream: bloc.orderFormSubject.stream,
      initialData: OrderForm.test(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        OrderForm form = snapshot.data;

        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    I18n.of(context).perPrice,
                    style: StyleFactory.subTitleStyle,
                  ),
                  Text(
                    "${form.unitPrice.amount} ${form.unitPrice.symbol}",
                    style: StyleFactory.smallCellTitleStyle,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    I18n.of(context).restAmount,
                    style: StyleFactory.subTitleStyle,
                  ),
                  Text(
                    "${form.remaining} 份",
                    style: StyleFactory.smallCellTitleStyle,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    I18n.of(context).investAmount,
                    style: StyleFactory.subTitleStyle,
                  ),
                  SizedBox(
                    width: 76,
                    child: IStep(
                      text: form.investAmount.toString(),
                      minusOnTap: () {
                        bloc.decreaseInvest();
                      },
                      plusOnTap: () {
                        bloc.increaseInvest();
                      },
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    I18n.of(context).takeProfit,
                    style: StyleFactory.subTitleStyle,
                  ),
                  SizedBox(
                    width: 76,
                    child: IStep(
                        text: "${form.takeProfit}%",
                        plusOnTap: () {
                          bloc.increaseTakeProfit();
                        },
                        minusOnTap: () {
                          bloc.decreaseTakeProfit();
                        }),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   children: <Widget>[
              //     Text(
              //       "${I18n.of(context).takeProfit}${I18n.of(context).gain}",
              //       style: StyleFactory.subTitleStyle,
              //     ),
              //     Text(
              //       "4 USDT",
              //       style: StyleFactory.smallCellTitleStyle,
              //     )
              //   ],
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Row(
                children: <Widget>[
                  Text(
                    I18n.of(context).cutLoss,
                    style: StyleFactory.subTitleStyle,
                  ),
                  SizedBox(
                    width: 76,
                    child: IStep(
                      text: "${form.cutoff}%",
                      plusOnTap: () {
                        bloc.increaseCutLoss();
                      },
                      minusOnTap: () {
                        bloc.decreaseCutLoss();
                      },
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   children: <Widget>[
              //     Text(
              //       "${I18n.of(context).cutLoss}${I18n.of(context).loss}",
              //       style: StyleFactory.subTitleStyle,
              //     ),
              //     Text(
              //       "4 USDT",
              //       style: StyleFactory.smallCellTitleStyle,
              //     )
              //   ],
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ),
            ],
          ),
        );
      },
    );
  }
}
