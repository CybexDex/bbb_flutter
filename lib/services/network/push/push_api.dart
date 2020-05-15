abstract class PushApi {
  Future<dynamic> registerPush({String accountName, String regId, int timeout});
  Future<dynamic> unRegisterPush({String accountName, String regId});
}
