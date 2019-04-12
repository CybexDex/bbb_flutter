import 'package:bbb_flutter/common/style_factory.dart';
import 'package:flutter/material.dart';

class ContractWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContractState();
}

class _ContractState extends State<ContractWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorationFactory.cornerShadowDecoration,
      height: 270,
    );
  }
}