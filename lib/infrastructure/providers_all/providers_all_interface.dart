import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/provider_item_response.dart';

abstract class ProvidersAllInterface {
  Future<ResponseWrapper<List<ProviderItemResponse>>> getAllProviders({
    @required int pageNumber,
    @required int pageSize,
  });
}
