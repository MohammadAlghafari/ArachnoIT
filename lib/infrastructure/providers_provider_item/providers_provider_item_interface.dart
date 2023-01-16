import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:flutter/material.dart';

abstract class ProvidersProviderItemInterface{
  Future<ResponseWrapper<bool>> setFavoriteProvider({
    @required String favoritePersonId,
    @required bool favoriteStatus,
  });
}