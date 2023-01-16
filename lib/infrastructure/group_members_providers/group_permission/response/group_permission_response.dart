class GroupPermission {
  int permissionType;
  String name;
  String id;
  bool isValid;

  GroupPermission({this.permissionType, this.name, this.id, this.isValid});

  GroupPermission.fromJson(Map<String, dynamic> json) {
    permissionType = json['permissionType'];
    name = json['name'];
    id = json['id'];
    isValid = json['isValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permissionType'] = this.permissionType;
    data['name'] = this.name;
    data['id'] = this.id;
    data['isValid'] = this.isValid;
    return data;
  }

  @override
  String toString() {
        return 'GroupPermission(permissionType: $permissionType, name: $name, id: $id, isValid: $isValid)';
  }
}