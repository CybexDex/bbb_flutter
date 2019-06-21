import 'package:rosetta/rosetta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';

part 'i18n.g.dart';

@Stone(path: 'i18n')
class I18n with _$I18nHelper {
  static LocalizationsDelegate<I18n> delegate = _$I18nDelegate();

  static I18n of(BuildContext context) => Localizations.of(context, I18n);
}
