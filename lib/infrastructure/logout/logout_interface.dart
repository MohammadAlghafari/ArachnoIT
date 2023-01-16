import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';

abstract class LogoutInterface {
  Future<ResponseWrapper<bool>> logoutUser(
      {@required String model,
      @required String product,
      @required String brand,
      @required String ip,
      @required int osApiLevel});
}
