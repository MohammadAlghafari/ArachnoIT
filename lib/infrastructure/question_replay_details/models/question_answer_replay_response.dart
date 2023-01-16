class QuestionAnswerReplayResponse {
  String answerId;
  String body;
  String id;
  bool isValid;

  QuestionAnswerReplayResponse({this.answerId, this.body, this.id, this.isValid});

  QuestionAnswerReplayResponse.fromJson(Map<String, dynamic> json) {
    answerId = json['answerId'];
    body = json['body'];
    id = json['id'];
    isValid = json['isValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answerId'] = this.answerId;
    data['body'] = this.body;
    data['id'] = this.id;
    data['isValid'] = this.isValid;
    return data;
  }
}