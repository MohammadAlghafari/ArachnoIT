import 'dart:convert';

class CommentReplyResponse {
  String id;
  String body;
  String creationDate;
  String personId;
  bool isHealthcareProvider;
  String firstName;
  String lastName;
  String inTouchPointName;
  String photoUrl;
  CommentReplyResponse({
    this.id,
    this.body,
    this.creationDate,
    this.personId,
    this.isHealthcareProvider,
    this.firstName,
    this.lastName,
    this.inTouchPointName,
    this.photoUrl,
  });

  CommentReplyResponse copyWith({
    String id,
    String body,
    String creationDate,
    String personId,
    bool isHealthcareProvider,
    String firstName,
    String lastName,
    String inTouchPointName,
    String photoUrl,
  }) {
    return CommentReplyResponse(
      id: id ?? this.id,
      body: body ?? this.body,
      creationDate: creationDate ?? this.creationDate,
      personId: personId ?? this.personId,
      isHealthcareProvider: isHealthcareProvider ?? this.isHealthcareProvider,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'creationDate': creationDate,
      'personId': personId,
      'isHealthcareProvider': isHealthcareProvider,
      'firstName': firstName,
      'lastName': lastName,
      'inTouchPointName': inTouchPointName,
      'photoUrl': photoUrl,
    };
  }

  factory CommentReplyResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CommentReplyResponse(
      id: map['id'],
      body: map['body'],
      creationDate: map['creationDate'],
      personId: map['personId'],
      isHealthcareProvider: map['isHealthcareProvider'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      inTouchPointName: map['inTouchPointName'],
      photoUrl: map['photoUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentReplyResponse.fromJson(String source) => CommentReplyResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BlogCommentReply(id: $id, body: $body, creationDate: $creationDate, personId: $personId, isHealthcareProvider: $isHealthcareProvider, firstName: $firstName, lastName: $lastName, inTouchPointName: $inTouchPointName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CommentReplyResponse &&
      o.id == id &&
      o.body == body &&
      o.creationDate == creationDate &&
      o.personId == personId &&
      o.isHealthcareProvider == isHealthcareProvider &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.inTouchPointName == inTouchPointName &&
      o.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      body.hashCode ^
      creationDate.hashCode ^
      personId.hashCode ^
      isHealthcareProvider.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      inTouchPointName.hashCode ^
      photoUrl.hashCode;
  }
}
