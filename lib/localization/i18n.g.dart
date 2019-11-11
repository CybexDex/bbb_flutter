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
  static final String registerErrorMessageShouldNotContainContinuesDash =
      'register_error_message_should_not_contain_continues_dash';

  static final String transfer = 'transfer';

  static final String cashRecords = 'cash_records';

  static final String transactionRecords = 'transaction_records';

  static final String recordEmpty = 'record_empty';

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

  static final String passwordError = 'password_error';

  static final String pinCode = 'pin_code';

  static final String pinCodeHint = 'pin_code_hint';

  static final String getPinCode = 'get_pin_code';

  static final String register = 'register';

  static final String createNewAccount = 'create_new_account';

  static final String alreadyRegister = 'already_register';

  static final String registerGoToLogIn = 'register_go_to_log_in';

  static final String welcomeRegister = 'welcome_register';

  static final String dialogCancelButton = 'dialog_cancel_button';

  static final String dialogSellTitle = 'dialog_sell_title';

  static final String dialogSellContent = 'dialog_sell_content';

  static final String dialogLogOutTitle = 'dialog_log_out_title';

  static final String dialogLogOutContent = 'dialog_log_out_content';

  static final String dialogLogOutConfirmButton =
      'dialog_log_out_confirm_button';

  static final String confirm = 'confirm';

  static final String remider = 'remider';

  static final String dialogCheckPassword = 'dialog_check_password';

  static final String registerErrorMessageContainLowercase =
      'register_error_message_contain_lowercase';

  static final String registerErrorMessageStartOnlyLetter =
      'register_error_message_start_only_letter';

  static final String registerErrorMessageShortNameLength =
      'register_error_message_short_name_length';

  static final String assetCat = 'asset_cat';

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

  static final String registerErrorMessageTooLong =
      'register_error_message_too_long';

  static final String registerWarningText = 'register_warning_text';

  static final String accountLogInError = 'account_log_in_error';

  static final String accountLogOut = 'account_log_out';

  static final String updatedDate = 'updated_date';

  static final String address = 'address';

  static final String fundStatusInProgress = 'fundStatus_inProgress';

  static final String fundStatusCompleted = 'fundStatus_completed';

  static final String fundStatusRejected = 'fundStatus_rejected';

  static final String fundStatusError = 'fundStatus_error';

  static final String tradingDetail = 'trading_detail';

  static final String openPositionPrice = 'open_position_price';

  static final String settlementPrice = 'settlement_price';

  static final String successToast = 'success_toast';

  static final String failToast = 'fail_toast';

  static final String leverage = 'leverage';

  static final String settlementTime = 'settlement_time';

  static final String openPositionTime = 'open_position_time';

  static final String settlementType = 'settlement_type';

  static final String accruedInterest = 'accruedInterest';

  static final String takeProfitCloseOut = 'take_profit_close_out';

  static final String cutLossCloseOut = 'cut_loss_close_out';

  static final String userCloseOut = 'user_close_out';

  static final String inviteFriend = 'invite_friend';

  static final String inviteTopRank = 'invite_top_rank';

  static final String inviteReward = 'invite_reward';

  static final String inviteRecommendSuc = 'invite_recommend_suc';

  static final String inviteMyPinCode = 'invite_my_pin_code';

  static final String inviteMyRecommender = 'invite_my_recommender';

  static final String inviteThreeStepOne = 'invite_three_step_one';

  static final String inviteThreeStepTwo = 'invite_three_step_two';

  static final String inviteThreeStepThree = 'invite_three_step_three';

  static final String inviteGainReward = 'invite_gain_reward';

  static final String inviteRecommendation = 'invite_recommendation';

  static final String inviteAddReferer = 'invite_add_referer';

  static final String inviteInputPinCode = 'invite_input_pin_code';

  static final String clickToTry = 'click_to_try';

  static final String clickToQuit = 'click_to_quit';

  static final String share = 'share';

  static final String oneMin = 'one_min';

  static final String fiveMin = 'five_min';

  static final String oneDay = 'one_day';

  static final String oneHour = 'one_hour';

  static final String changeEnv = 'change_env';

  static final String chooseEnv = 'choose_env';

  static final String chooseEnvDetail = 'choose_env_detail';

  static final String investmentHint = 'investment_hint';

  static final String changeToTryEnv = 'change_to_try_env';

  static final String changeFromTryEnv = 'change_from_try_env';

  static final String orderFormReset = 'order_form_reset';

  static final String orderFormBalanceNotEnoughError =
      'order_form_balance_not_enough_error';

  static final String orderFormSupplyNotEnoughError =
      'order_form_supply_not_enough_error';

  static final String orderFormInputPositiveNumberError =
      'order_form_input_positive_number_error';

  static final String orderFormBuyLimitationError =
      'order_form_buy_limitation_error';

  static final String stepWidgetNotSetHint = 'step_widget_not_set_hint';

  static final String transferBbbAccount = 'transfer_bbb_account';

  static final String transferCybexAccount = 'transfer_cybex_account';

  static final String transferTo = 'transfer_to';

  static final String transferFrom = 'transfer_from';

  static final String transferAmount = 'transfer_amount';

  static final String forumSource = 'forum_source';

  static final String transferAmountHint = 'transfer_amount_hint';

  static final String transferAll = 'transfer_all';

  static final String transferErrorMessageCybNotEnough =
      'transfer_error_message_cyb_not_enough';

  static final String transferErrorMessageBbbNotEnough =
      'transfer_error_message_bbb_not_enough';

  static final String transferNow = 'transfer_now';

  static final String noFeeError = 'no_fee_error';

  static final String savePhotoSuccess = 'save_photo_success';

  static final String savePhotoFail = 'save_photo_fail';

  static final String requestPermissionTitle = 'request_permission_title';

  static final String requestPermissionContent = 'request_permission_content';

  static final String totalPnl = 'total_pnl';

  static final String toastNoContract = 'toast_no_contract';

  static final String helpCenter = 'help_center';

  static final String rewardAccount = 'reward_account';

  static final String quitReward = 'quit_reward';

  static final String changeToReward = 'change_to_reward';

  static final String depositParagraph = 'deposit_paragraph';

  static final String withdrawParagraph = 'withdraw_paragraph';

  static final String forceClosePrice = 'force_close_price';

  static final String type = 'type';

  static final String version = 'version';

  static final String triggerCloseContent = 'trigger_close_content';

  static final String pnl = 'pnl';

  static final String percentageUp = 'percentage_up';

  static final String percentageDown = 'percentage_down';

  static final String investAmountOrderInfo = 'invest_amount_order_info';

  static final String updateTitle = 'update_title';

  static final String connectToWifi = 'connect_to_wifi';

  static final String connectToMobile = 'connect_to_mobile';

  static final String noConnection = 'no_connection';

  static final String suspend = 'suspend';

  static final String error1001 = 'error_1001';

  static final String error1002 = 'error_1002';

  static final String error1004 = 'error_1004';

  static final String error1005 = 'error_1005';

  static final String error1013 = 'error_1013';

  static final String error1014 = 'error_1014';

  static final String error1016 = 'error_1016';

  static final String error1017 = 'error_1017';

  static final String error1018 = 'error_1018';

  static final String error1019 = 'error_1019';

  static final String error1020 = 'error_1020';

  static final String error1021 = 'error_1021';

  static final String error1022 = 'error_1022';

  static final String error1023 = 'error_1023';

  static final String error1024 = 'error_1024';

  static final String error1025 = 'error_1025';

  static final String error1026 = 'error_1026';

  static final String error1027 = 'error_1027';

  static final String error1028 = 'error_1028';

  static final String error1029 = 'error_1029';

  static final String error1030 = 'error_1030';

  static final String error1031 = 'error_1031';

  static final String error1032 = 'error_1032';

  static final String error1033 = 'error_1033';

  static final String error1034 = 'error_1034';

  static final String error1035 = 'error_1035';

  static final String error1036 = 'error_1036';

  static final String error1037 = 'error_1037';

  static final String error1038 = 'error_1038';

  static final String forum = 'forum';

  static final String astrology = 'astrology';

  static final String blockchainVip = 'blockchain_vip';

  static final String news = 'news';

  static final String forumCreate = 'forum_create';

  static final String forumAuthor = 'forum_author';

  static final String transferAvailableAmount = 'transfer_available_amount';
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
  String get registerErrorMessageShouldNotContainContinuesDash =>
      this._translate(_$Keys.registerErrorMessageShouldNotContainContinuesDash);
  String get transfer => this._translate(_$Keys.transfer);
  String get cashRecords => this._translate(_$Keys.cashRecords);
  String get transactionRecords => this._translate(_$Keys.transactionRecords);
  String get recordEmpty => this._translate(_$Keys.recordEmpty);
  String get logout => this._translate(_$Keys.logout);
  String get myAsset => this._translate(_$Keys.myAsset);
  String get withdraw => this._translate(_$Keys.withdraw);
  String get all => this._translate(_$Keys.all);
  String get buyUp => this._translate(_$Keys.buyUp);
  String get buyDown => this._translate(_$Keys.buyDown);
  String get topUp => this._translate(_$Keys.topUp);
  String get amend => this._translate(_$Keys.amend);
  String get closeOut => this._translate(_$Keys.closeOut);
  String get orderEmpty => this._translate(_$Keys.orderEmpty);
  String get myOrdersStock => this._translate(_$Keys.myOrdersStock);
  String get nextRoundStart => this._translate(_$Keys.nextRoundStart);
  String get roundEnd => this._translate(_$Keys.roundEnd);
  String get futureProfit => this._translate(_$Keys.futureProfit);
  String get takeProfit => this._translate(_$Keys.takeProfit);
  String get cutLoss => this._translate(_$Keys.cutLoss);
  String get actLevel => this._translate(_$Keys.actLevel);
  String get invest => this._translate(_$Keys.invest);
  String get investPay => this._translate(_$Keys.investPay);
  String get interestRate => this._translate(_$Keys.interestRate);
  String get perDay => this._translate(_$Keys.perDay);
  String get forceExpiration => this._translate(_$Keys.forceExpiration);
  String get forcePrice => this._translate(_$Keys.forcePrice);
  String get perPrice => this._translate(_$Keys.perPrice);
  String get restAmount => this._translate(_$Keys.restAmount);
  String get rest => this._translate(_$Keys.rest);
  String get investAmount => this._translate(_$Keys.investAmount);
  String get gain => this._translate(_$Keys.gain);
  String get loss => this._translate(_$Keys.loss);
  String get containFee => this._translate(_$Keys.containFee);
  String get fee => this._translate(_$Keys.fee);
  String get balance => this._translate(_$Keys.balance);
  String get balanceAvailable => this._translate(_$Keys.balanceAvailable);
  String get logIn => this._translate(_$Keys.logIn);
  String get accountName => this._translate(_$Keys.accountName);
  String get accountNameHint => this._translate(_$Keys.accountNameHint);
  String get password => this._translate(_$Keys.password);
  String get passwordHint => this._translate(_$Keys.passwordHint);
  String get passwordConfirm => this._translate(_$Keys.passwordConfirm);
  String get passwordConfirmHint => this._translate(_$Keys.passwordConfirmHint);
  String get passwordError => this._translate(_$Keys.passwordError);
  String get pinCode => this._translate(_$Keys.pinCode);
  String get pinCodeHint => this._translate(_$Keys.pinCodeHint);
  String get getPinCode => this._translate(_$Keys.getPinCode);
  String get register => this._translate(_$Keys.register);
  String get createNewAccount => this._translate(_$Keys.createNewAccount);
  String get alreadyRegister => this._translate(_$Keys.alreadyRegister);
  String get registerGoToLogIn => this._translate(_$Keys.registerGoToLogIn);
  String get welcomeRegister => this._translate(_$Keys.welcomeRegister);
  String get dialogCancelButton => this._translate(_$Keys.dialogCancelButton);
  String get dialogSellTitle => this._translate(_$Keys.dialogSellTitle);
  String get dialogSellContent => this._translate(_$Keys.dialogSellContent);
  String get dialogLogOutTitle => this._translate(_$Keys.dialogLogOutTitle);
  String get dialogLogOutContent => this._translate(_$Keys.dialogLogOutContent);
  String get dialogLogOutConfirmButton =>
      this._translate(_$Keys.dialogLogOutConfirmButton);
  String get confirm => this._translate(_$Keys.confirm);
  String get remider => this._translate(_$Keys.remider);
  String get dialogCheckPassword => this._translate(_$Keys.dialogCheckPassword);
  String get registerErrorMessageContainLowercase =>
      this._translate(_$Keys.registerErrorMessageContainLowercase);
  String get registerErrorMessageStartOnlyLetter =>
      this._translate(_$Keys.registerErrorMessageStartOnlyLetter);
  String get registerErrorMessageShortNameLength =>
      this._translate(_$Keys.registerErrorMessageShortNameLength);
  String get assetCat => this._translate(_$Keys.assetCat);
  String get registerErrorMessageDashEnd =>
      this._translate(_$Keys.registerErrorMessageDashEnd);
  String get registerErrorMessageOnlyContainLetter =>
      this._translate(_$Keys.registerErrorMessageOnlyContainLetter);
  String get registerErrorMessageAccountHasAlreadyExist =>
      this._translate(_$Keys.registerErrorMessageAccountHasAlreadyExist);
  String get registerErrorMessagePasswordChecker =>
      this._translate(_$Keys.registerErrorMessagePasswordChecker);
  String get registerErrorMessagePasswordConfirm =>
      this._translate(_$Keys.registerErrorMessagePasswordConfirm);
  String get registerErrorMessageTooLong =>
      this._translate(_$Keys.registerErrorMessageTooLong);
  String get registerWarningText => this._translate(_$Keys.registerWarningText);
  String get accountLogInError => this._translate(_$Keys.accountLogInError);
  String get accountLogOut => this._translate(_$Keys.accountLogOut);
  String get updatedDate => this._translate(_$Keys.updatedDate);
  String get address => this._translate(_$Keys.address);
  String get fundStatusInProgress =>
      this._translate(_$Keys.fundStatusInProgress);
  String get fundStatusCompleted => this._translate(_$Keys.fundStatusCompleted);
  String get fundStatusRejected => this._translate(_$Keys.fundStatusRejected);
  String get fundStatusError => this._translate(_$Keys.fundStatusError);
  String get tradingDetail => this._translate(_$Keys.tradingDetail);
  String get openPositionPrice => this._translate(_$Keys.openPositionPrice);
  String get settlementPrice => this._translate(_$Keys.settlementPrice);
  String get successToast => this._translate(_$Keys.successToast);
  String get failToast => this._translate(_$Keys.failToast);
  String get leverage => this._translate(_$Keys.leverage);
  String get settlementTime => this._translate(_$Keys.settlementTime);
  String get openPositionTime => this._translate(_$Keys.openPositionTime);
  String get settlementType => this._translate(_$Keys.settlementType);
  String get accruedInterest => this._translate(_$Keys.accruedInterest);
  String get takeProfitCloseOut => this._translate(_$Keys.takeProfitCloseOut);
  String get cutLossCloseOut => this._translate(_$Keys.cutLossCloseOut);
  String get userCloseOut => this._translate(_$Keys.userCloseOut);
  String get inviteFriend => this._translate(_$Keys.inviteFriend);
  String get inviteTopRank => this._translate(_$Keys.inviteTopRank);
  String get inviteReward => this._translate(_$Keys.inviteReward);
  String get inviteRecommendSuc => this._translate(_$Keys.inviteRecommendSuc);
  String get inviteMyPinCode => this._translate(_$Keys.inviteMyPinCode);
  String get inviteMyRecommender => this._translate(_$Keys.inviteMyRecommender);
  String get inviteThreeStepOne => this._translate(_$Keys.inviteThreeStepOne);
  String get inviteThreeStepTwo => this._translate(_$Keys.inviteThreeStepTwo);
  String get inviteThreeStepThree =>
      this._translate(_$Keys.inviteThreeStepThree);
  String get inviteGainReward => this._translate(_$Keys.inviteGainReward);
  String get inviteRecommendation =>
      this._translate(_$Keys.inviteRecommendation);
  String get inviteAddReferer => this._translate(_$Keys.inviteAddReferer);
  String get inviteInputPinCode => this._translate(_$Keys.inviteInputPinCode);
  String get clickToTry => this._translate(_$Keys.clickToTry);
  String get clickToQuit => this._translate(_$Keys.clickToQuit);
  String get share => this._translate(_$Keys.share);
  String get oneMin => this._translate(_$Keys.oneMin);
  String get fiveMin => this._translate(_$Keys.fiveMin);
  String get oneDay => this._translate(_$Keys.oneDay);
  String get oneHour => this._translate(_$Keys.oneHour);
  String get changeEnv => this._translate(_$Keys.changeEnv);
  String get chooseEnv => this._translate(_$Keys.chooseEnv);
  String get chooseEnvDetail => this._translate(_$Keys.chooseEnvDetail);
  String get investmentHint => this._translate(_$Keys.investmentHint);
  String get changeToTryEnv => this._translate(_$Keys.changeToTryEnv);
  String get changeFromTryEnv => this._translate(_$Keys.changeFromTryEnv);
  String get orderFormReset => this._translate(_$Keys.orderFormReset);
  String get orderFormBalanceNotEnoughError =>
      this._translate(_$Keys.orderFormBalanceNotEnoughError);
  String get orderFormSupplyNotEnoughError =>
      this._translate(_$Keys.orderFormSupplyNotEnoughError);
  String get orderFormInputPositiveNumberError =>
      this._translate(_$Keys.orderFormInputPositiveNumberError);
  String get orderFormBuyLimitationError =>
      this._translate(_$Keys.orderFormBuyLimitationError);
  String get stepWidgetNotSetHint =>
      this._translate(_$Keys.stepWidgetNotSetHint);
  String get transferBbbAccount => this._translate(_$Keys.transferBbbAccount);
  String get transferCybexAccount =>
      this._translate(_$Keys.transferCybexAccount);
  String get transferTo => this._translate(_$Keys.transferTo);
  String get transferFrom => this._translate(_$Keys.transferFrom);
  String get transferAmount => this._translate(_$Keys.transferAmount);
  String get forumSource => this._translate(_$Keys.forumSource);
  String get transferAmountHint => this._translate(_$Keys.transferAmountHint);
  String get transferAll => this._translate(_$Keys.transferAll);
  String get transferErrorMessageCybNotEnough =>
      this._translate(_$Keys.transferErrorMessageCybNotEnough);
  String get transferErrorMessageBbbNotEnough =>
      this._translate(_$Keys.transferErrorMessageBbbNotEnough);
  String get transferNow => this._translate(_$Keys.transferNow);
  String get noFeeError => this._translate(_$Keys.noFeeError);
  String get savePhotoSuccess => this._translate(_$Keys.savePhotoSuccess);
  String get savePhotoFail => this._translate(_$Keys.savePhotoFail);
  String get requestPermissionTitle =>
      this._translate(_$Keys.requestPermissionTitle);
  String get requestPermissionContent =>
      this._translate(_$Keys.requestPermissionContent);
  String get totalPnl => this._translate(_$Keys.totalPnl);
  String get toastNoContract => this._translate(_$Keys.toastNoContract);
  String get helpCenter => this._translate(_$Keys.helpCenter);
  String get rewardAccount => this._translate(_$Keys.rewardAccount);
  String get quitReward => this._translate(_$Keys.quitReward);
  String get changeToReward => this._translate(_$Keys.changeToReward);
  String get depositParagraph => this._translate(_$Keys.depositParagraph);
  String get withdrawParagraph => this._translate(_$Keys.withdrawParagraph);
  String get forceClosePrice => this._translate(_$Keys.forceClosePrice);
  String get type => this._translate(_$Keys.type);
  String get version => this._translate(_$Keys.version);
  String get triggerCloseContent => this._translate(_$Keys.triggerCloseContent);
  String get pnl => this._translate(_$Keys.pnl);
  String get percentageUp => this._translate(_$Keys.percentageUp);
  String get percentageDown => this._translate(_$Keys.percentageDown);
  String get investAmountOrderInfo =>
      this._translate(_$Keys.investAmountOrderInfo);
  String get updateTitle => this._translate(_$Keys.updateTitle);
  String get connectToWifi => this._translate(_$Keys.connectToWifi);
  String get connectToMobile => this._translate(_$Keys.connectToMobile);
  String get noConnection => this._translate(_$Keys.noConnection);
  String get suspend => this._translate(_$Keys.suspend);
  String get error1001 => this._translate(_$Keys.error1001);
  String get error1002 => this._translate(_$Keys.error1002);
  String get error1004 => this._translate(_$Keys.error1004);
  String get error1005 => this._translate(_$Keys.error1005);
  String get error1013 => this._translate(_$Keys.error1013);
  String get error1014 => this._translate(_$Keys.error1014);
  String get error1016 => this._translate(_$Keys.error1016);
  String get error1017 => this._translate(_$Keys.error1017);
  String get error1018 => this._translate(_$Keys.error1018);
  String get error1019 => this._translate(_$Keys.error1019);
  String get error1020 => this._translate(_$Keys.error1020);
  String get error1021 => this._translate(_$Keys.error1021);
  String get error1022 => this._translate(_$Keys.error1022);
  String get error1023 => this._translate(_$Keys.error1023);
  String get error1024 => this._translate(_$Keys.error1024);
  String get error1025 => this._translate(_$Keys.error1025);
  String get error1026 => this._translate(_$Keys.error1026);
  String get error1027 => this._translate(_$Keys.error1027);
  String get error1028 => this._translate(_$Keys.error1028);
  String get error1029 => this._translate(_$Keys.error1029);
  String get error1030 => this._translate(_$Keys.error1030);
  String get error1031 => this._translate(_$Keys.error1031);
  String get error1032 => this._translate(_$Keys.error1032);
  String get error1033 => this._translate(_$Keys.error1033);
  String get error1034 => this._translate(_$Keys.error1034);
  String get error1035 => this._translate(_$Keys.error1035);
  String get error1036 => this._translate(_$Keys.error1036);
  String get error1037 => this._translate(_$Keys.error1037);
  String get error1038 => this._translate(_$Keys.error1038);
  String get forum => this._translate(_$Keys.forum);
  String get astrology => this._translate(_$Keys.astrology);
  String get blockchainVip => this._translate(_$Keys.blockchainVip);
  String get news => this._translate(_$Keys.news);
  String get forumCreate => this._translate(_$Keys.forumCreate);
  String get forumAuthor => this._translate(_$Keys.forumAuthor);
  String get transferAvailableAmount =>
      this._translate(_$Keys.transferAvailableAmount);
}
