import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetGroupMembersRemoteDataProvider {
  const GetGroupMembersRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getGroupMembers({
    @required String idGroup,
    @required bool includeHealthcareProvidersOnly,
    @required String query,
    @required bool enablePagination,
    @required int pageNumber,
    @required int pageSize,
    @required bool getNonGroupMembersOnly,
  }) async {
    final params = {
      'itemId': idGroup ?? "",
      'includeHealthcareProvidersOnly': includeHealthcareProvidersOnly ?? false,
      'query': query ?? "",
      'enablePagination': enablePagination ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? 20,
      'GetNonGroupMembersOnly': getNonGroupMembersOnly ?? true,
    };
    Response response = await dio.get(Urls.Get_Group_Members, queryParameters: params);
    return response;
  }

  Future<dynamic> removeMemberFromGroup({
    @required List<String> membersId,
    @required String groupId,
  }) async {

    Response response = await dio.delete(Urls.Remove_Members_From_Group, queryParameters:  {"groupId": groupId}, data: membersId);
    return response;
  }
}
