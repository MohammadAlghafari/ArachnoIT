import 'dart:convert';

class SpecificationResponse {
  String accountTypeId;
  String name;
  String id;
  bool isValid;
  

  SpecificationResponse({
    this.accountTypeId,
    this.name,
    this.id,
    this.isValid,
  });

  Map<String, dynamic> toMap() {
    return {
      'accountTypeId': accountTypeId,
      'name': name,
      'id': id,
      'isValid': isValid,
      
    };
  }

  factory SpecificationResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SpecificationResponse(
      accountTypeId: map['accountTypeId'],
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
     
    );
  }

  String toJson() => json.encode(toMap());

  factory SpecificationResponse.fromJson(String source) =>
      SpecificationResponse.fromMap(json.decode(source));
}
