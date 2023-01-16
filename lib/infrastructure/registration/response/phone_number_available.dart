import 'dart:convert';

class PhoneNumberAvailableResponse {
  bool isAvailable;
  bool isConfirmed;
  

  PhoneNumberAvailableResponse({
    this.isAvailable,
    this.isConfirmed,
  });

  Map<String, dynamic> toMap() {
    return {
      'isAvailable': isAvailable,
      'isConfirmed': isConfirmed,
      
    };
  }

  factory PhoneNumberAvailableResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return PhoneNumberAvailableResponse(
      isAvailable: map['isAvailable'],
      isConfirmed: map['isConfirmed'],
     
    );
  }

  String toJson() => json.encode(toMap());

  factory PhoneNumberAvailableResponse.fromJson(String source) =>
      PhoneNumberAvailableResponse.fromMap(json.decode(source));
}
