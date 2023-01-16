// To parse this JSON data, do
//
//     final providerGeneralInfoResponse = providerGeneralInfoResponseFromJson(jsonString);

import 'dart:convert';

ProviderGeneralInfoResponse providerGeneralInfoResponseFromJson(String str) => ProviderGeneralInfoResponse.fromJson(json.decode(str));

String providerGeneralInfoResponseToJson(ProviderGeneralInfoResponse data) => json.encode(data.toJson());

class ProviderGeneralInfoResponse {
    ProviderGeneralInfoResponse({
        this.subSpecification,
        this.about,
        this.whatWeDo,
        this.inTouchPointName,
    });

    String subSpecification;
    String about;
    String whatWeDo;
    String inTouchPointName;

    factory ProviderGeneralInfoResponse.fromJson(Map<String, dynamic> json) => ProviderGeneralInfoResponse(
        subSpecification: json["subSpecification"] == null ? "null" : json["subSpecification"],
        about: json["about"] == null ? "null" : json["about"],
        whatWeDo: json["whatWeDo"] == null ? "null" : json["whatWeDo"],
        inTouchPointName: json["inTouchPointName"] == null ? "null" : json["inTouchPointName"],
    );

    Map<String, dynamic> toJson() => {
        "subSpecification": subSpecification == null ? "null" : subSpecification,
        "about": about == null ? "null" : about,
        "whatWeDo": whatWeDo == null ? "null" : whatWeDo,
        "inTouchPointName": inTouchPointName == null ? "null" : inTouchPointName,
    };
}
