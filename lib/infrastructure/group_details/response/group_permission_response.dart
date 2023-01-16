import 'dart:convert';

class GroupPermissionResponse {
  int permissionType;
  String name;
  String id;
  bool isValid;
  GroupPermissionResponse({
    this.permissionType,
    this.name,
    this.id,
    this.isValid,
  });

  GroupPermissionResponse copyWith({
    int permissionType,
    String name,
    String id,
    bool isValid,
  }) {
    return GroupPermissionResponse(
      permissionType: permissionType ?? this.permissionType,
      name: name ?? this.name,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'permissionType': permissionType,
      'name': name,
      'id': id,
      'isValid': isValid,
    };
  }

  factory GroupPermissionResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return GroupPermissionResponse(
      permissionType: map['permissionType'],
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupPermissionResponse.fromJson(String source) => GroupPermissionResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupPermissionResponse(permissionType: $permissionType, name: $name, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is GroupPermissionResponse &&
      o.permissionType == permissionType &&
      o.name == name &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode {
    return permissionType.hashCode ^ name.hashCode ^ id.hashCode ^ isValid.hashCode;
  }
}
