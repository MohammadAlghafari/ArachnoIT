import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/provider_item_response.dart';
import 'package:flutter/material.dart';

abstract class ProvidersFavoriteInterface {
  Future<ResponseWrapper<List<ProviderItemResponse>>> getFavoriteProviders({
    @required String searchString,
    @required int pageNumber,
    @required int pageSize,
  });
}
