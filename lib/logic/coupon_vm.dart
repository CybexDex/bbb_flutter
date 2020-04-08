import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/coupon_response.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/types.dart';

class CouponViewModel extends BaseModel {
  final UserManager _um;
  final BBBAPI _bbbapi;
  List<Coupon> pendingCoupon = [];
  List<Coupon> usedCoupon = [];
  var totalAmount;

  CouponViewModel({UserManager um, BBBAPI bbbapi})
      : _um = um,
        _bbbapi = bbbapi;

  getCoupons() async {
    var response = await _bbbapi
        .getCoupons(name: _um.user.name, status: [CouponStatus.pending, CouponStatus.activated]);
    pendingCoupon = response?.coupon;
    getTotalAmount();
    setBusy(false);
  }

  getUsedCoupons() async {
    var response = await _bbbapi.getCoupons(
        name: _um.user.name,
        status: [CouponStatus.activateFailed, CouponStatus.expired, CouponStatus.used]);
    usedCoupon = response.coupon;
    setBusy(false);
  }

  getTotalAmount() {
    totalAmount = 0;
    pendingCoupon.forEach((coupon) {
      totalAmount += coupon.amount;
    });
  }
}
