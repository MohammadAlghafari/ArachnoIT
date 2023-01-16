import 'dart:convert';

class EmailAvailableResponse {
  bool isAvailable;
  bool isConfirmed;
  

  EmailAvailableResponse({
    this.isAvailable,
    this.isConfirmed,
  });

  Map<String, dynamic> toMap() {
    return {
      'isAvailable': isAvailable,
      'isConfirmed': isConfirmed,
      
    };
  }

  factory EmailAvailableResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return EmailAvailableResponse(
      isAvailable: map['isAvailable'],
      isConfirmed: map['isConfirmed'],
     
    );
  }

  String toJson() => json.encode(toMap());

  factory EmailAvailableResponse.fromJson(String source) =>
      EmailAvailableResponse.fromMap(json.decode(source));
}
