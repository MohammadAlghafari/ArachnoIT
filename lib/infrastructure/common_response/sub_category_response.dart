import 'dart:convert';


class SubCategoryResponse {
  bool isSubscribedTo;
  int questionsCount;
  int blogsCount;
  int groupsCount;
  String name;
  String id;
  bool isValid;
  SubCategoryResponse({
    this.isSubscribedTo,
    this.questionsCount,
    this.blogsCount,
    this.groupsCount,
    this.name,
    this.id,
    this.isValid,
  });

  SubCategoryResponse copyWith({
    bool isSubscribedTo,
    int questionsCount,
    int blogsCount,
    int groupsCount,
    String name,
    String id,
    bool isValid,
  }) {
    return SubCategoryResponse(
      isSubscribedTo: isSubscribedTo ?? this.isSubscribedTo,
      questionsCount: questionsCount ?? this.questionsCount,
      blogsCount: blogsCount ?? this.blogsCount,
      groupsCount: groupsCount ?? this.groupsCount,
      name: name ?? this.name,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isSubscribedTo': isSubscribedTo,
      'questionsCount': questionsCount,
      'blogsCount': blogsCount,
      'groupsCount': groupsCount,
      'name': name,
      'id': id,
      'isValid': isValid,
    };
  }

  factory SubCategoryResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SubCategoryResponse(
      isSubscribedTo: map['isSubscribedTo'],
      questionsCount: map['questionsCount'],
      blogsCount: map['blogsCount'],
      groupsCount: map['groupsCount'],
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCategoryResponse.fromJson(String source) => SubCategoryResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubCategoryResponse(isSubscribedTo: $isSubscribedTo, questionsCount: $questionsCount, blogsCount: $blogsCount, groupsCount: $groupsCount, name: $name, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SubCategoryResponse &&
      o.isSubscribedTo == isSubscribedTo &&
      o.questionsCount == questionsCount &&
      o.blogsCount == blogsCount &&
      o.groupsCount == groupsCount &&
      o.name == name &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode {
    return isSubscribedTo.hashCode ^
      questionsCount.hashCode ^
      blogsCount.hashCode ^
      groupsCount.hashCode ^
      name.hashCode ^
      id.hashCode ^
      isValid.hashCode;
  }
}
