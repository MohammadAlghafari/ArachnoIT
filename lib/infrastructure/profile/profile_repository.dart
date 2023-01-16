import 'dart:io';

import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/specification_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_specification_response.dart';
import 'package:arachnoit/infrastructure/profile/call/get_profile_country.dart';
import 'package:arachnoit/infrastructure/profile/call/profile_get_specification.dart';
import 'package:arachnoit/infrastructure/profile/call/set_contact_info.dart';
import 'package:arachnoit/infrastructure/profile/call/set_profile_image.dart';
import 'package:arachnoit/infrastructure/profile/call/set_provider_general_info.dart';
import 'package:arachnoit/infrastructure/profile/call/set_social_media_link.dart';
import 'package:arachnoit/infrastructure/profile/response/contact_response.dart';
import 'package:arachnoit/infrastructure/profile/response/person_profile_basic_info_response.dart';
import 'package:arachnoit/infrastructure/profile/response/personal_profile_photos.dart';
import 'package:arachnoit/infrastructure/profile/response/provider_general_info_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/call/get_profile_educatios.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/call/get_profile_certificate.dart';
import 'package:arachnoit/infrastructure/profile/call/get_profile_info.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/call/get_profile_language.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/call/get_profile_lecture.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/call/get_profile_projects.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/call/get_profile_skills.dart';
import 'package:arachnoit/infrastructure/profile/profile_interface.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/infrastructure/registration/response/country_reponse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import '../profile_provider_courses/call/get_profile_courses.dart';
import '../profile_provider_experiance/call/get_profile_experiance.dart';
import 'call/profile_get_sub_specification.dart';
import 'call/set_normal_user_general_info.dart';

class ProfileRepository implements ProfileInterface {
  final GetProfileInfo getProfileInfo;
  final SetContactInfo setContactInfo;
  final GetProfileCountry getProfileCountry;
  final ProfileGetSpecification profileGetSpecification;
  final SetSocailMedialLink setSocailMedialLink;
  final ProfileGetSubSpecification profileGetSubSpecification;
  final SetProfileImage setProfileImage;
  final SetProviderGeneralInfo setProviderGeneralInfo;
  final SetNormalUserGeneralInfo setNormalUserGeneralInfo;
  ProfileRepository({
    @required this.getProfileInfo,
    @required this.setContactInfo,
    @required this.getProfileCountry,
    @required this.setSocailMedialLink,
    @required this.profileGetSpecification,
    @required this.profileGetSubSpecification,
    @required this.setProfileImage,
    @required this.setProviderGeneralInfo,
    @required this.setNormalUserGeneralInfo,
  });
  @override
  Future<ResponseWrapper<ProfileInfoResponse>> getUserProfileInfo(
      {@required String userId}) async {
    try {
      Response response =
          await getProfileInfo.getUserProfileInfo(userId: userId);
      return _prepareGetUserProfileInfo(remoteResponse: response);
    } on DioError catch (e) {
      print("the error  is Dio$e");

      return _prepareGetUserProfileInfo(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareGetUserProfileInfo(remoteResponse: null);
    }
  }

  ResponseWrapper<ProfileInfoResponse> _prepareGetUserProfileInfo(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<ProfileInfoResponse>();
    if (remoteResponse != null) {
      res.data = ProfileInfoResponse.fromJson(remoteResponse.data);
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<bool>> updateSocailMediaLink({
    String facebook,
    String twiter,
    String instagram,
    String telegram,
    String youtube,
    String whatsApp,
    String linkedIn,
  }) async {
    try {
      Response response = await setSocailMedialLink.setSocail(
        facebook: facebook,
        twiter: twiter,
        instagram: instagram,
        telegram: telegram,
        youtube: youtube,
        whatsApp: whatsApp,
        linkedIn: linkedIn,
      );
      return _prepareUpdateSocailMediaLink(remoteResponse: response);
    } on DioError catch (e) {
      print("the error  is Dio$e");

      return _prepareUpdateSocailMediaLink(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareUpdateSocailMediaLink(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareUpdateSocailMediaLink(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      res.data = false;
      if (remoteResponse.statusCode == 200) res.data = true;
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<ContactResponse>> updateContactInfo({
    String personId,
    String cityId,
    String phone,
    String workPhone,
    String mobile,
    String address,
  }) async {
    try {
      Response response = await setContactInfo.setContactInfo(
        address: address,
        cityId: cityId,
        mobile: mobile,
        personId: personId,
        phone: phone,
        workPhone: workPhone,
      );
      return _prepareUpdateContactInfo(remoteResponse: response);
    } on DioError catch (e) {
      print("the error  is Dio$e");

      return _prepareUpdateContactInfo(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareUpdateContactInfo(remoteResponse: null);
    }
  }

  ResponseWrapper<ContactResponse> _prepareUpdateContactInfo(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<ContactResponse>();
    if (remoteResponse != null) {
      res.data = ContactResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;

      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<List<CountryResponse>>> getCountries() async {
    try {
      Response response = await getProfileCountry.getCountries();
      return _prepareCountriesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCountriesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<CountryResponse>> _prepareCountriesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CountryResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => CountryResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<List<SpecificationResponse>>> getSpecification(
      {accountTypeId}) async {
    try {
      Response response = await profileGetSpecification.getSpecification(
        accountTypeId: accountTypeId,
      );
      return _prepareSpecificationResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSpecificationResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<SpecificationResponse>> _prepareSpecificationResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<SpecificationResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => SpecificationResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<List<SubSpecificationResponse>>> getSubSpecification(
      {specificationId}) async {
    try {
      Response response = await profileGetSubSpecification.getSubSpecification(
        specificationId: specificationId,
      );
      return _prepareSubSpecificationResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSubSpecificationResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<SubSpecificationResponse>>
      _prepareSubSpecificationResponse(
          {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<SubSpecificationResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => SubSpecificationResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<PersonalProfilePhotos>> setOrRemoveImage({
    File image,
    bool isDeleteImage,
  }) async {
    try {
      Response response = await setProfileImage.setImage(
          imagePath: image, removeFile: isDeleteImage);
      return _prepareSetOrRemoveImage(remoteResponse: response);
    } on DioError catch (e) {
      print("The erros is $e");
      return null;
    } catch (e) {
      print("The erros is $e");
      return null;
    }
  }

  ResponseWrapper<PersonalProfilePhotos> _prepareSetOrRemoveImage(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<PersonalProfilePhotos>();
    if (remoteResponse != null) {
      res.data =
          PersonalProfilePhotos.fromJson(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<List<dynamic>>> setProfileProviderGeneralInfo({
    String firstName,
    String lastName,
    int gender,
    String birthdate,
    String summary,
    String inTouchPointName,
    String subSpecificationId,
    String organizationTypeId,
  }) async {
    try {
      List<Response> responses =
          await setProviderGeneralInfo.setProviderGeneralInfo(
        birthdate: birthdate,
        firstName: firstName,
        gender: gender,
        inTouchPointName: inTouchPointName,
        lastName: lastName,
        organizationTypeId: organizationTypeId,
        subSpecificationId: subSpecificationId,
        summary: summary,
      );
      return _prepareSetProfileProviderGeneralInfo(
        remoteResponses: responses,
      );
    } on DioError catch (e) {
      return _prepareSetProfileProviderGeneralInfo(remoteResponses: null);
    } catch (e) {
      return _prepareSetProfileProviderGeneralInfo(remoteResponses: null);
    }
  }

  ResponseWrapper<List<dynamic>> _prepareSetProfileProviderGeneralInfo(
      {@required List<Response> remoteResponses}) {
    var res = ResponseWrapper<List<dynamic>>();
    if (remoteResponses != null) {
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      res.data = [];
      if (remoteResponses[0].statusCode == 200 &&
          remoteResponses[1].statusCode == 200)
        res.responseType = ResType.ResponseType.SUCCESS;
      else if (remoteResponses[0].statusCode == 400 ||
          remoteResponses[1].statusCode == 400 ||
          remoteResponses[0].statusCode == 401 ||
          remoteResponses[1].statusCode == 401)
        res.responseType = ResType.ResponseType.VALIDATION_ERROR;
      else if (remoteResponses[0].statusCode == 500 ||
          remoteResponses[1].statusCode == 500)
        res.responseType = ResType.ResponseType.SERVER_ERROR;
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<PersonProfileBasicInfoResponse>>
      setProfileNormalUserGeneralInfo({
    String firstName,
    String lastName,
    int gender,
    String birthdate,
    String summary,
  }) async {
    try {
      Response responses =
          await setNormalUserGeneralInfo.setNormalUserGeneralInfo(
        birthdate: birthdate,
        firstName: firstName,
        gender: gender,
        lastName: lastName,
        summary: summary,
      );
      return _preparSetProfileNormalUserGeneralInfo(remoteResponse: responses);
    } catch (e) {
      return e;
    }
  }

  ResponseWrapper<PersonProfileBasicInfoResponse>
      _preparSetProfileNormalUserGeneralInfo(
          {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<PersonProfileBasicInfoResponse>();
    if (remoteResponse != null) {
      res.data = res.data = PersonProfileBasicInfoResponse.fromJson(
          remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
