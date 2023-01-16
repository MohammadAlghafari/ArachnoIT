import 'dart:io';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/repository/certificate_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/repository/new_certificate_response.dart';

abstract class ProfileProviderCertificateInterface {
  Future<ResponseWrapper<List<CertificateResponse>>> getUserProfileCertificate({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });

  Future<ResponseWrapper<NewCertificateResponse>> addNewCertificate({
    String name,
    String issueDate,
    String expirationDate,
    String organization,
    String url,
    File file,
  });

  Future<ResponseWrapper<NewCertificateResponse>> updateSelectedCertificate(
      {String id,
      String name,
      String issueDate,
      String expirationDate,
      String organization,
      String url,
      File file,
      List<String> removedfiles});

  Future<ResponseWrapper<bool>> deleteSelectedCertificate({
    String itemId,
  });
}
