import 'package:flutter/material.dart';

enum RequestType { Accept, Leave }

class GetDepartmentParam {
  final int pageNumber;
  final int pageSize;
  final String healthCareProviderId;

  GetDepartmentParam({
    @required this.pageNumber,
    @required this.pageSize,
    @required this.healthCareProviderId,
  });
}

class JoinOrLeaveDepartmentParam {
  final String departmentId;
  final RequestType requestType;

  JoinOrLeaveDepartmentParam({
    @required this.departmentId,
    @required this.requestType,
  });
}