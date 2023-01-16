import 'dart:convert';

class CitiesByCountryResponse {
  String name;
  String id;
  bool isValid;
  CitiesByCountryResponse({
    this.name,
    this.id,
    this.isValid,
  });
  

  

  CitiesByCountryResponse copyWith({
    String name,
    String id,
    bool isValid,
  }) {
    return CitiesByCountryResponse(
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

  factory CitiesByCountryResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CitiesByCountryResponse(
      name: map['name'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CitiesByCountryResponse.fromJson(String source) => CitiesByCountryResponse.fromMap(json.decode(source));

 
}
