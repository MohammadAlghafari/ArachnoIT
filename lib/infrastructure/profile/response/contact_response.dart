// To parse this JSON data, do
//
//     final contactResponse = contactResponseFromJson(jsonString);

import 'dart:convert';

ContactResponse contactResponseFromJson(String str) => ContactResponse.fromJson(json.decode(str));

String contactResponseToJson(ContactResponse data) => json.encode(data.toJson());

class ContactResponse {
    ContactResponse({
        this.personId,
        this.cityId,
        this.phone,
        this.workPhone,
        this.mobile,
        this.address,
    });

    String personId;
    String cityId;
    String phone;
    String workPhone;
    String mobile;
    String address;

    factory ContactResponse.fromJson(Map<String, dynamic> json) => ContactResponse(
        personId: json["personId"] == null ? "null" : json["personId"],
        cityId: json["cityId"] == null ? "null" : json["cityId"],
        phone: json["phone"] == null ? "null" : json["phone"],
        workPhone: json["workPhone"] == null ? "null" : json["workPhone"],
        mobile: json["mobile"] == null ? "null" : json["mobile"],
        address: json["address"] == null ? "null" : json["address"],
    );

    Map<String, dynamic> toJson() => {
        "personId": personId == null ? "null" : personId,
        "cityId": cityId == null ? "null" : cityId,
        "phone": phone == null ? "null" : phone,
        "workPhone": workPhone == null ? "null" : workPhone,
        "mobile": mobile == null ? "null" : mobile,
        "address": address == null ? "null" : address,
    };
}
