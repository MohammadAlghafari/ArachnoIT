import 'dart:convert';

class TagResponse {
  String id;
  String name;
  TagResponse({
    this.id,
    this.name,
  });

  TagResponse copyWith({
    String id,
    String name,
  }) {
    return TagResponse(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory TagResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TagResponse(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TagResponse.fromJson(String source) => TagResponse.fromMap(json.decode(source));

  @override
  String toString() => 'TagResponse(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TagResponse &&
      o.id == id &&
      o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
