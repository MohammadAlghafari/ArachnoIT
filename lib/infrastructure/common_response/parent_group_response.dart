import 'dart:convert';

class ParentGroupResponse {
  String name;
  String id;
  bool isValid;
  ParentGroupResponse({
    this.name,
    this.id,
    this.isValid,
  });

  ParentGroupResponse copyWith({
    String name,
    String id,
    bool isValid,
  }) {
    return ParentGroupResponse(
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

  factory ParentGroupResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ParentGroupResponse(
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ParentGroupResponse.fromJson(String source) => ParentGroupResponse.fromMap(json.decode(source));

  @override
  String toString() => 'ParentGroupResponse(name: $name, id: $id, isValid: $isValid)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ParentGroupResponse &&
      o.name == name &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ isValid.hashCode;
}
