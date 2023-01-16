import 'dart:convert';

class GroupCategoryResponse {
  String name;
  String id;
  bool isValid;
  GroupCategoryResponse({
    this.name,
    this.id,
    this.isValid,
  });

  GroupCategoryResponse copyWith({
    String name,
    String id,
    bool isValid,
  }) {
    return GroupCategoryResponse(
      name: name ?? this.name,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'isValid': isValid,
    };
  }

  factory GroupCategoryResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return GroupCategoryResponse(
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupCategoryResponse.fromJson(String source) => GroupCategoryResponse.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryResponse(name: $name, id: $id, isValid: $isValid)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is GroupCategoryResponse &&
      o.name == name &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ isValid.hashCode;
}
