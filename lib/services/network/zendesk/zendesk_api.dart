import 'package:bbb_flutter/models/response/bbb_kb_response.dart';
import 'package:bbb_flutter/models/response/zendesk_advertise_reponse_model.dart';

abstract class ZendeskApi {
  Future<ZendeskAdvertiseResponse> getZendeskAdvertise({int count, String sortBy});
  Future<List<BBBKBResponse>> getKBList();
}
