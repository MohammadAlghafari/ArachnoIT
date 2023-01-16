import 'dart:io';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/specification_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_specification_response.dart';
import 'package:arachnoit/infrastructure/profile/response/contact_response.dart';
import 'package:arachnoit/infrastructure/profile/response/person_profile_basic_info_response.dart';
import 'package:arachnoit/infrastructure/profile/response/personal_profile_photos.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/infrastructure/registration/response/country_reponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileInterface {
  Future<ResponseWrapper<ProfileInfoResponse>> getUserProfileInfo(
      {@required String userId});
  Future<ResponseWrapper<ContactResponse>> updateContactInfo({
    String personId,
    String cityId,
    String phone,
    String workPhone,
    String mobile,
    String address,
  });
  Future<ResponseWrapper<List<CountryResponse>>> getCountries();
  Future<ResponseWrapper<bool>> updateSocailMediaLink({
    String facebook,
    String twiter,
    String instagram,
    String telegram,
    String youtube,
    String whatsApp,
    String linkedIn,
  });

  Future<ResponseWrapper<List<SpecificationResponse>>> getSpecification(
      {@required accountTypeId});

  Future<ResponseWrapper<List<SubSpecificationResponse>>> getSubSpecification({
    @required specificationId,
  });

  Future<ResponseWrapper<PersonalProfilePhotos>> setOrRemoveImage({
    File image,
    bool isDeleteImage,
  });

  Future<ResponseWrapper<List<dynamic>>> setProfileProviderGeneralInfo({
    String firstName,
    String lastName,
    int gender,
    String birthdate,
    String summary,
    String inTouchPointName,
    String subSpecificationId,
    String organizationTypeId,
  });

  Future<ResponseWrapper<PersonProfileBasicInfoResponse>> setProfileNormalUserGeneralInfo({
    String firstName,
    String lastName,
    int gender,
    String birthdate,
    String summary,
  });

}
