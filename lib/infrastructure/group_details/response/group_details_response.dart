import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../common_response/file_response.dart';
import '../../common_response/group_category_response.dart';
import '../../common_response/group_owner_response.dart';
import '../../common_response/group_sub_category_response.dart';
import '../../common_response/parent_group_response.dart';
import 'child_group_response.dart';
import 'group_member_response.dart';

class GroupDetailsResponse {
  List<GroupMemberResponse> groupMembers;
  List<ChildGroupResponse> childrenGroup;
  String name;
  String description;
  FileResponse image;
  int requestStatus;
  int privacyLevel;
  GroupOwnerResponse owner;
  String groupId;
  List<int> loginUserGroupPermissions;
  ParentGroupResponse parentGroup;
  int blogsCount;
  int questionsCount;
  int researchesCount;
  int membersCount;
  List<GroupSubCategoryResponse> subCategories;
  GroupCategoryResponse category;
  String ownerId;
  String id;
  bool isValid;
  GroupDetailsResponse({
    this.groupMembers,
    this.childrenGroup,
    this.name,
    this.description,
    this.image,
    this.requestStatus,
    this.privacyLevel,
    this.owner,
    this.groupId,
    this.loginUserGroupPermissions,
    this.parentGroup,
    this.blogsCount,
    this.questionsCount,
    this.researchesCount,
    this.membersCount,
    this.subCategories,
    this.category,
    this.ownerId,
    this.id,
    this.isValid,
  });

  GroupDetailsResponse copyWith({
    List<GroupMemberResponse> groupMembers,
    List<ChildGroupResponse> childrenGroup,
    String name,
    String description,
    FileResponse image,
    int requestStatus,
    int privacyLevel,
    GroupOwnerResponse owner,
    String groupId,
    List<int> loginUserGroupPermissions,
    ParentGroupResponse parentGroup,
    int blogsCount,
    int questionsCount,
    int researchesCount,
    int membersCount,
    List<GroupSubCategoryResponse> subCategories,
    GroupCategoryResponse category,
    String ownerId,
    String id,
    bool isValid,
  }) {
    return GroupDetailsResponse(
      groupMembers: groupMembers ?? this.groupMembers,
      childrenGroup: childrenGroup ?? this.childrenGroup,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      requestStatus: requestStatus ?? this.requestStatus,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      owner: owner ?? this.owner,
      groupId: groupId ?? this.groupId,
      loginUserGroupPermissions:
          loginUserGroupPermissions ?? this.loginUserGroupPermissions,
      parentGroup: parentGroup ?? this.parentGroup,
      blogsCount: blogsCount ?? this.blogsCount,
      questionsCount: questionsCount ?? this.questionsCount,
      researchesCount: researchesCount ?? this.researchesCount,
      membersCount: membersCount ?? this.membersCount,
      subCategories: subCategories ?? this.subCategories,
      category: category ?? this.category,
      ownerId: ownerId ?? this.ownerId,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupMembers': groupMembers?.map((x) => x?.toMap())?.toList(),
      'childrenGroup': childrenGroup?.map((x) => x?.toMap())?.toList(),
      'name': name,
      'description': description,
      'image': image?.toMap(),
      'requestStatus': requestStatus,
      'privacyLevel': privacyLevel,
      'owner': owner?.toMap(),
      'groupId': groupId,
      'loginUserGroupPermissions': loginUserGroupPermissions,
      'parentGroup': parentGroup?.toMap(),
      'blogsCount': blogsCount,
      'questionsCount': questionsCount,
      'researchesCount': researchesCount,
      'membersCount': membersCount,
      'subCategories': subCategories?.map((x) => x?.toMap())?.toList(),
      'category': category?.toMap(),
      'ownerId': ownerId,
      'id': id,
      'isValid': isValid,
    };
  }

  factory GroupDetailsResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GroupDetailsResponse(
      groupMembers:map['groupMembers'].toString().isNotEmpty? List<GroupMemberResponse>.from(map['groupMembers']?.map((x) => GroupMemberResponse.fromMap(x))):[],
      childrenGroup: map['childrenGroup'] != null
          ? List<ChildGroupResponse>.from(
              map['childrenGroup']?.map((x) => ChildGroupResponse.fromMap(x)))
          : null,
      name: map['name'],
      description: map['description'],
      image: map['image']==null?FileResponse():FileResponse.fromMap(map['image']),
      requestStatus: map['requestStatus']??-1,
      privacyLevel: map['privacyLevel'],
      owner: GroupOwnerResponse.fromMap(map['owner']),
      groupId: map['groupId'],
      loginUserGroupPermissions: map['loginUserGroupPermissions'] != null
          ? List<int>.from(map['loginUserGroupPermissions'])
          : null,
      parentGroup: ParentGroupResponse.fromMap(map['parentGroup']),
      blogsCount: map['blogsCount'],
      questionsCount: map['questionsCount'],
      researchesCount: map['researchesCount'],
      membersCount: map['membersCount'],
      subCategories: List<GroupSubCategoryResponse>.from(map['subCategories']
          ?.map((x) => GroupSubCategoryResponse.fromMap(x))),
      category: GroupCategoryResponse.fromMap(map['category']),
      ownerId: map['ownerId'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupDetailsResponse.fromJson(String source) =>
      GroupDetailsResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupDetailsResponse(groupMembers: $groupMembers, childrenGroup: $childrenGroup, name: $name, description: $description, image: $image, requestStatus: $requestStatus, privacyLevel: $privacyLevel, owner: $owner, groupId: $groupId, loginUserGroupPermissions: $loginUserGroupPermissions, parentGroup: $parentGroup, blogsCount: $blogsCount, questionsCount: $questionsCount, researchesCount: $researchesCount, membersCount: $membersCount, subCategories: $subCategories, category: $category, ownerId: $ownerId, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GroupDetailsResponse &&
        listEquals(o.groupMembers, groupMembers) &&
        listEquals(o.childrenGroup, childrenGroup) &&
        o.name == name &&
        o.description == description &&
        o.image == image &&
        o.requestStatus == requestStatus &&
        o.privacyLevel == privacyLevel &&
        o.owner == owner &&
        o.groupId == groupId &&
        listEquals(o.loginUserGroupPermissions, loginUserGroupPermissions) &&
        o.parentGroup == parentGroup &&
        o.blogsCount == blogsCount &&
        o.questionsCount == questionsCount &&
        o.researchesCount == researchesCount &&
        o.membersCount == membersCount &&
        listEquals(o.subCategories, subCategories) &&
        o.category == category &&
        o.ownerId == ownerId &&
        o.id == id &&
        o.isValid == isValid;
  }

  @override
  int get hashCode {
    return groupMembers.hashCode ^
        childrenGroup.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        requestStatus.hashCode ^
        privacyLevel.hashCode ^
        owner.hashCode ^
        groupId.hashCode ^
        loginUserGroupPermissions.hashCode ^
        parentGroup.hashCode ^
        blogsCount.hashCode ^
        questionsCount.hashCode ^
        researchesCount.hashCode ^
        membersCount.hashCode ^
        subCategories.hashCode ^
        category.hashCode ^
        ownerId.hashCode ^
        id.hashCode ^
        isValid.hashCode;
  }
}
