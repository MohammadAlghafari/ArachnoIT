class CategoryAndSubResponse {
  bool isSubscribedTo;
  int questionsCount;
  int blogsCount;
  int groupsCount;
  String name;
  String id;
  bool isValid;

  CategoryAndSubResponse(
      {this.isSubscribedTo,
        this.questionsCount,
        this.blogsCount,
        this.groupsCount,
        this.name,
        this.id,
        this.isValid});

  CategoryAndSubResponse.fromJson(Map<String, dynamic> json) {
    isSubscribedTo = json['isSubscribedTo'];
    questionsCount = json['questionsCount'];
    blogsCount = json['blogsCount'];
    groupsCount = json['groupsCount'];
    name = json['name'];
    id = json['id'];
    isValid = json['isValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSubscribedTo'] = this.isSubscribedTo;
    data['questionsCount'] = this.questionsCount;
    data['blogsCount'] = this.blogsCount;
    data['groupsCount'] = this.groupsCount;
    data['name'] = this.name;
    data['id'] = this.id;
    data['isValid'] = this.isValid;
    return data;
  }
}