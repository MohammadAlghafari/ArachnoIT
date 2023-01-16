import 'dart:convert';

class QuestionAnswerCommentResponse {
  String commentId;
  String body;
  String creationDate;
  String personId;
  bool isHealthcareProvider;
  String firstName;
  String lastName;
  String inTouchPointName;
  String photoUrl;
  QuestionAnswerCommentResponse({
    this.commentId,
    this.body,
    this.creationDate,
    this.personId,
    this.isHealthcareProvider,
    this.firstName,
    this.lastName,
    this.inTouchPointName,
    this.photoUrl,
  });


  QuestionAnswerCommentResponse copyWith({
    String commentId,
    String body,
    String creationDate,
    String personId,
    bool isHealthcareProvider,
    String firstName,
    String lastName,
    String inTouchPointName,
    String photoUrl,
  }) {
    return QuestionAnswerCommentResponse(
      commentId: commentId ?? this.commentId,
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
      'commentId': commentId,
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

  factory QuestionAnswerCommentResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return QuestionAnswerCommentResponse(
      commentId: map['commentId'],
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

  factory QuestionAnswerCommentResponse.fromJson(String source) => QuestionAnswerCommentResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentResponse(commentId: $commentId, body: $body, creationDate: $creationDate, personId: $personId, isHealthcareProvider: $isHealthcareProvider, firstName: $firstName, lastName: $lastName, inTouchPointName: $inTouchPointName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is QuestionAnswerCommentResponse &&
      o.commentId == commentId &&
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
    return commentId.hashCode ^
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
