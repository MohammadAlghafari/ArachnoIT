import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'sub_category_response.dart';

class CategoryResponse {
  String categoryImageUrl;
  List<SubCategoryResponse> subCategories;
  bool isSubscribedTo;
  int questionsCount;
  int blogsCount;
  int groupsCount;
  String name;
  String categoryImage;
  String id;
  bool isValid;
  CategoryResponse({
    this.categoryImageUrl,
    this.subCategories,
    this.isSubscribedTo,
    this.questionsCount,
    this.blogsCount,
    this.groupsCount,
    this.name,
    this.id,
    this.isValid,
    this.categoryImage,
  });

  CategoryResponse copyWith(
      {String categoryImageUrl,
      List<SubCategoryResponse> subCategories,
      bool isSubscribedTo,
      int questionsCount,
      int blogsCount,
      int groupsCount,
      String name,
      String id,
      bool isValid,
      String categoryImage}) {
    return CategoryResponse(
        categoryImageUrl: categoryImageUrl ?? this.categoryImageUrl,
        subCategories: subCategories ?? this.subCategories,
        isSubscribedTo: isSubscribedTo ?? this.isSubscribedTo,
        questionsCount: questionsCount ?? this.questionsCount,
        blogsCount: blogsCount ?? this.blogsCount,
        groupsCount: groupsCount ?? this.groupsCount,
        name: name ?? this.name,
        id: id ?? this.id,
        isValid: isValid ?? this.isValid,
        categoryImage: categoryImage ?? this.categoryImage);
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryImageUrl': categoryImageUrl,
      'subCategories': subCategories?.map((x) => x?.toMap())?.toList(),
      'isSubscribedTo': isSubscribedTo,
      'questionsCount': questionsCount,
      'blogsCount': blogsCount,
      'groupsCount': groupsCount,
      'name': name,
      'id': id,
      'isValid': isValid,
      "categoryImage": categoryImage,
    };
  }

  factory CategoryResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CategoryResponse(
      categoryImageUrl: map['categoryImageUrl'],
      subCategories: map['subCategories'] != null
          ? List<SubCategoryResponse>.from(
              map['subCategories']?.map((x) => SubCategoryResponse.fromMap(x)))
          : null,
      isSubscribedTo: map['isSubscribedTo'],
      questionsCount: map['questionsCount'],
      blogsCount: map['blogsCount'],
      groupsCount: map['groupsCount'],
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
      categoryImage: map['categoryImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryResponse.fromJson(String source) =>
      CategoryResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryResponse(categoryImageUrl: $categoryImageUrl, subCategories: $subCategories, isSubscribedTo: $isSubscribedTo, questionsCount: $questionsCount, blogsCount: $blogsCount, groupsCount: $groupsCount, name: $name, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CategoryResponse &&
        o.categoryImageUrl == categoryImageUrl &&
        listEquals(o.subCategories, subCategories) &&
        o.isSubscribedTo == isSubscribedTo &&
        o.questionsCount == questionsCount &&
        o.blogsCount == blogsCount &&
        o.groupsCount == groupsCount &&
        o.name == name &&
        o.id == id &&
        o.isValid == isValid &&
        o.categoryImage == categoryImage;
  }

  @override
  int get hashCode {
    return categoryImageUrl.hashCode ^
        subCategories.hashCode ^
        isSubscribedTo.hashCode ^
        questionsCount.hashCode ^
        blogsCount.hashCode ^
        groupsCount.hashCode ^
        name.hashCode ^
        id.hashCode ^
        isValid.hashCode ^
        categoryImage.hashCode;
  }
}
