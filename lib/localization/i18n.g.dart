// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i18n.dart';

// **************************************************************************
// RosettaStoneGenerator
// **************************************************************************

/// A factory for a set of localized resources of type I18n, to be loaded by a
/// [Localizations] widget.
class _$I18nDelegate extends LocalizationsDelegate<I18n> {
  /// Whether the the given [locale.languageCode] code has a JSON associated with it.
  @override
  bool isSupported(Locale locale) =>
      const ['zh', 'en'].contains(locale.languageCode);

  /// Returns true if the resources for this delegate should be loaded
  /// again by calling the [load] method.
  @override
  bool shouldReload(LocalizationsDelegate<I18n> old) => false;

  /// Loads the JSON associated with the given [locale] using [Strings].
  @override
  Future<I18n> load(Locale locale) async {
    var i18n = I18n();
    await i18n.load(locale);
    return i18n;
  }
}

/// Contains the keys read from the JSON
class _$Keys {
  static final String cashRecords = 'cash_records';

  static final String transactionRecords = 'transaction_records';

  static final String logout = 'logout';

  static final String myAsset = 'my_asset';

  static final String withdraw = 'withdraw';

  static final String all = 'all';

  static final String buyUp = 'buy_up';

  static final String buyDown = 'buy_down';

  static final String topUp = 'top_up';

  static final String amend = 'amend';

  static final String closeOut = 'close_out';

  static final String orderEmpty = 'order_empty';

  static final String myOrdersStock = 'my_orders_stock';

  static final String nextRoundStart = 'next_round_start';

  static final String roundEnd = 'round_end';

  static final String futureProfit = 'future_profit';

  static final String takeProfit = 'take_profit';

  static final String cutLoss = 'cut_loss';

  static final String actLevel = 'act_level';

  static final String invest = 'invest';

  static final String investPay = 'invest_pay';

  static final String interestRate = 'interest_rate';

  static final String perDay = 'per_day';

  static final String forceExpiration = 'force_expiration';

  static final String forcePrice = 'force_price';

  static final String perPrice = 'per_price';

  static final String restAmount = 'rest_amount';

  static final String rest = 'rest';

  static final String investAmount = 'invest_amount';

  static final String gain = 'gain';

  static final String loss = 'loss';

  static final String containFee = 'contain_fee';

  static final String fee = 'fee';

  static final String balance = 'balance';

  static final String balanceAvailable = 'balance_available';

  static final String logIn = 'log_in';

  static final String accountName = 'account_name';

  static final String accountNameHint = 'account_name_hint';

  static final String password = 'password';

  static final String passwordHint = 'password_hint';

  static final String passwordConfirm = 'password_confirm';

  static final String passwordConfirmHint = 'password_confirm_hint';

  static final String pinCode = 'pin_code';

  static final String pinCodeHint = 'pin_code_hint';

  static final String getPinCode = 'get_pin_code';

  static final String register = 'register';

  static final String createNewAccount = 'create_new_account';

  static final String alreadyRegister = 'already_register';

  static final String dialogCancelButton = 'dialog_cancel_button';

  static final String dialogSellTitle = 'dialog_sell_title';

  static final String dialogSellContent = 'dialog_sell_content';

  static final String dialogLogOutTitle = 'dialog_log_out_title';

  static final String dialogLogOutContent = 'dialog_log_out_content';

  static final String dialogLogOutConfirmButton =
      'dialog_log_out_confirm_button';

  static final String confirm = 'confirm';

  static final String registerErrorMessageContainLowercase =
      'register_error_message_contain_lowercase';

  static final String registerErrorMessageStartOnlyLetter =
      'register_error_message_start_only_letter';

  static final String registerErrorMessageShortNameLength =
      'register_error_message_short_name_length';

  static final String registerErrorMessageShouldNotContainContinuesDash =
      'register_error_message_should_not_contain_continues_dash';

  static final String registerErrorMessageDashEnd =
      'register_error_message_dash_end';

  static final String registerErrorMessageOnlyContainLetter =
      'register_error_message_only_contain_letter';

  static final String registerErrorMessageAccountHasAlreadyExist =
      'register_error_message_account_has_already_exist';

  static final String registerErrorMessagePasswordChecker =
      'register_error_message_password_checker';

  static final String registerErrorMessagePasswordConfirm =
      'register_error_message_password_confirm';

  static final String accountLogInError = 'account_log_in_error';

  static final String accountLogOut = 'account_log_out';

  static final String updatedDate = 'updated_date';

  static final String address = 'address';

  static final String fundStatusInProgress = 'fundStatus_inProgress';

  static final String fundStatusCompleted = 'fundStatus_completed';

  static final String fundStatusRejected = 'fundStatus_rejected';

  static final String fundStatusError = 'fundStatus_error';
}

/// Loads and allows access to string resources provided by the JSON
/// for the specified [Locale].
///
/// Should be used as an abstract or mixin class for [I18n].
abstract class _$I18nHelper {
  Map<String, String> _translations;

  /// Loads and decodes the JSON associated with the given [locale].
  Future<void> load(Locale locale) async {
    var jsonStr =
        await rootBundle.loadString('i18n/${locale.languageCode}.json');
    Map jsonMap = json.decode(jsonStr);
    _translations = jsonMap
        .map<String, String>((key, value) => MapEntry(key, value as String));
  }

  /// Returns the requested string resource associated with the given [key].
  String _translate(String key) => _translations[key];

  /// Simple getter methods
  String get cashRecords => _translate(_$Keys.cashRecords);
  String get transactionRecords => _translate(_$Keys.transactionRecords);
  String get logout => _translate(_$Keys.logout);
  String get myAsset => _translate(_$Keys.myAsset);
  String get withdraw => _translate(_$Keys.withdraw);
  String get all => _translate(_$Keys.all);
  String get buyUp => _translate(_$Keys.buyUp);
  String get buyDown => _translate(_$Keys.buyDown);
  String get topUp => _translate(_$Keys.topUp);
  String get amend => _translate(_$Keys.amend);
  String get closeOut => _translate(_$Keys.closeOut);
  String get orderEmpty => _translate(_$Keys.orderEmpty);
  String get myOrdersStock => _translate(_$Keys.myOrdersStock);
  String get nextRoundStart => _translate(_$Keys.nextRoundStart);
  String get roundEnd => _translate(_$Keys.roundEnd);
  String get futureProfit => _translate(_$Keys.futureProfit);
  String get takeProfit => _translate(_$Keys.takeProfit);
  String get cutLoss => _translate(_$Keys.cutLoss);
  String get actLevel => _translate(_$Keys.actLevel);
  String get invest => _translate(_$Keys.invest);
  String get investPay => _translate(_$Keys.investPay);
  String get interestRate => _translate(_$Keys.interestRate);
  String get perDay => _translate(_$Keys.perDay);
  String get forceExpiration => _translate(_$Keys.forceExpiration);
  String get forcePrice => _translate(_$Keys.forcePrice);
  String get perPrice => _translate(_$Keys.perPrice);
  String get restAmount => _translate(_$Keys.restAmount);
  String get rest => _translate(_$Keys.rest);
  String get investAmount => _translate(_$Keys.investAmount);
  String get gain => _translate(_$Keys.gain);
  String get loss => _translate(_$Keys.loss);
  String get containFee => _translate(_$Keys.containFee);
  String get fee => _translate(_$Keys.fee);
  String get balance => _translate(_$Keys.balance);
  String get balanceAvailable => _translate(_$Keys.balanceAvailable);
  String get logIn => _translate(_$Keys.logIn);
  String get accountName => _translate(_$Keys.accountName);
  String get accountNameHint => _translate(_$Keys.accountNameHint);
  String get password => _translate(_$Keys.password);
  String get passwordHint => _translate(_$Keys.passwordHint);
  String get passwordConfirm => _translate(_$Keys.passwordConfirm);
  String get passwordConfirmHint => _translate(_$Keys.passwordConfirmHint);
  String get pinCode => _translate(_$Keys.pinCode);
  String get pinCodeHint => _translate(_$Keys.pinCodeHint);
  String get getPinCode => _translate(_$Keys.getPinCode);
  String get register => _translate(_$Keys.register);
  String get createNewAccount => _translate(_$Keys.createNewAccount);
  String get alreadyRegister => _translate(_$Keys.alreadyRegister);
  String get dialogCancelButton => _translate(_$Keys.dialogCancelButton);
  String get dialogSellTitle => _translate(_$Keys.dialogSellTitle);
  String get dialogSellContent => _translate(_$Keys.dialogSellContent);
  String get dialogLogOutTitle => _translate(_$Keys.dialogLogOutTitle);
  String get dialogLogOutContent => _translate(_$Keys.dialogLogOutContent);
  String get dialogLogOutConfirmButton =>
      _translate(_$Keys.dialogLogOutConfirmButton);
  String get confirm => _translate(_$Keys.confirm);
  String get registerErrorMessageContainLowercase =>
      _translate(_$Keys.registerErrorMessageContainLowercase);
  String get registerErrorMessageStartOnlyLetter =>
      _translate(_$Keys.registerErrorMessageStartOnlyLetter);
  String get registerErrorMessageShortNameLength =>
      _translate(_$Keys.registerErrorMessageShortNameLength);
  String get registerErrorMessageShouldNotContainContinuesDash =>
      _translate(_$Keys.registerErrorMessageShouldNotContainContinuesDash);
  String get registerErrorMessageDashEnd =>
      _translate(_$Keys.registerErrorMessageDashEnd);
  String get registerErrorMessageOnlyContainLetter =>
      _translate(_$Keys.registerErrorMessageOnlyContainLetter);
  String get registerErrorMessageAccountHasAlreadyExist =>
      _translate(_$Keys.registerErrorMessageAccountHasAlreadyExist);
  String get registerErrorMessagePasswordChecker =>
      _translate(_$Keys.registerErrorMessagePasswordChecker);
  String get registerErrorMessagePasswordConfirm =>
      _translate(_$Keys.registerErrorMessagePasswordConfirm);
  String get accountLogInError => _translate(_$Keys.accountLogInError);
  String get accountLogOut => _translate(_$Keys.accountLogOut);
  String get updatedDate => _translate(_$Keys.updatedDate);
  String get address => _translate(_$Keys.address);
  String get fundStatusInProgress => _translate(_$Keys.fundStatusInProgress);
  String get fundStatusCompleted => _translate(_$Keys.fundStatusCompleted);
  String get fundStatusRejected => _translate(_$Keys.fundStatusRejected);
  String get fundStatusError => _translate(_$Keys.fundStatusError);
}
