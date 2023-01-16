import 'dart:convert';

class CountryResponse {
  String key;
  String name;
  String id;
  bool isValid;
  

  CountryResponse({
    this.key,
    this.name,
    this.id,
    this.isValid,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'name': name,
      'id': id,
      'isValid': isValid,
      
    };
  }

  factory CountryResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CountryResponse(
      key: map['key'],
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
     
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryResponse.fromJson(String source) =>
      CountryResponse.fromMap(json.decode(source));
}
