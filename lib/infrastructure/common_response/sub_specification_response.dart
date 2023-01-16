import 'dart:convert';

class SubSpecificationResponse {
  String name;
  String id;
  bool isValid;
  

  SubSpecificationResponse({
    this.name,
    this.id,
    this.isValid,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'isValid': isValid,
      
    };
  }

  factory SubSpecificationResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SubSpecificationResponse(
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
     
    );
  }

  String toJson() => json.encode(toMap());

  factory SubSpecificationResponse.fromJson(String source) =>
      SubSpecificationResponse.fromMap(json.decode(source));
}
