import 'dart:convert';

class TouchPointNameAvailableResponse {
  bool touchPointAvailable;
  

  TouchPointNameAvailableResponse({
    this.touchPointAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      'touchPointAvailable': touchPointAvailable,
      
    };
  }

  factory TouchPointNameAvailableResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TouchPointNameAvailableResponse(
      touchPointAvailable: map['touchPointAvailable'],
     
    );
  }

  String toJson() => json.encode(toMap());

  factory TouchPointNameAvailableResponse.fromJson(String source) =>
      TouchPointNameAvailableResponse.fromMap(json.decode(source));
}
