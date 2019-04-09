
import 'package:bbb_flutter/models/ref_data.dart';

abstract class BBBAPI {
  Future<RefData> getRefData();
}
