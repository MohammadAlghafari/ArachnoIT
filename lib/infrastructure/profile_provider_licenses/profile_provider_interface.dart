import 'dart:io';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/licenses_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/new_license_response.dart';

abstract class ProfileProviderInterface {
  Future<ResponseWrapper<List<LicensesResponse>>> getUserProfileLicenses({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });

  Future<ResponseWrapper<NewLicenseResponse>> addNewLicense(
      {String title, String description, File file});
  Future<ResponseWrapper<NewLicenseResponse>> updateSelectedLicense(
      {String title, String description, File file, String id});
  Future<ResponseWrapper<bool>> deleteSelectedLicenses({
    String itemId,
  });
}
