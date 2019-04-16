import 'package:magical_widget/magical_widget.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quiver/iterables.dart';

part 'my_active_order_bloc.g.dart';

@Alakazam()
enum myLoginScreen {
  enableMobileTxt$bool$true,
  enableSendBtn$bool,
  mobileTxt$string,
  numberDigitsExpected$num$9
}