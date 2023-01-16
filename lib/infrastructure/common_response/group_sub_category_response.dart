import 'dart:convert';

class GroupSubCategoryResponse {
   String name;
  String id;
  bool isValid;
  GroupSubCategoryResponse({
    this.name,
    this.id,
    this.isValid,
  });

  GroupSubCategoryResponse copyWith({
    String name,
    String id,
    bool isValid,
  }) {
    return GroupSubCategoryResponse(
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

  factory GroupSubCategoryResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return GroupSubCategoryResponse(
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupSubCategoryResponse.fromJson(String source) => GroupSubCategoryResponse.fromMap(json.decode(source));

  @override
  String toString() => 'SubCategoryResponse(name: $name, id: $id, isValid: $isValid)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is GroupSubCategoryResponse &&
      o.name == name &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ isValid.hashCode;
}
