import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetSocailMedialLink {
  final Dio dio;
  SetSocailMedialLink({@required this.dio});
  Future<dynamic> setSocail({
    String facebook,
    String twiter,
    String instagram,
    String telegram,
    String youtube,
    String whatsApp,
    String linkedIn,
  }) async {
    final _param = {
      "facebook": facebook,
      "twiter": twiter,
      "instagram": instagram,
      "telegram": telegram,
      "youtube": youtube,
      "whatsApp": whatsApp,
      "linkedIn": linkedIn
    };
    Response response = await dio.put(Urls.SET_SOCIAL_MEDIA_LINK, data: _param);
    return response;
  }
}
