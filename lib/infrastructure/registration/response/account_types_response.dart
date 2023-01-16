import 'dart:convert';

class AccountTypesResponse {
  String name;
  String specficationName;
  String subSpecificationName;
  String description;
  int template;
  String id;
  bool isValid;
  AccountTypesResponse({
    this.name,
    this.specficationName,
    this.subSpecificationName,
    this.description,
    this.template,
    this.id,
    this.isValid,
  });

  AccountTypesResponse copyWith({
    String name,
    String specficationName,
    String subSpecificationName,
    String description,
    int template,
    String id,
    bool isValid,
  }) {
    return AccountTypesResponse(
      name: name ?? this.name,
      specficationName: specficationName ?? this.specficationName,
      subSpecificationName: subSpecificationName ?? this.subSpecificationName,
      description: description ?? this.description,
      template: template ?? this.template,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specficationName': specficationName,
      'subSpecificationName': subSpecificationName,
      'description': description,
      'template': template,
      'id': id,
      'isValid': isValid,
    };
  }

  factory AccountTypesResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AccountTypesResponse(
      name: map['name'],
      specficationName: map['specficationName'],
      subSpecificationName: map['subSpecificationName'],
      description: map['description'],
      template: map['template'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountTypesResponse.fromJson(String source) => AccountTypesResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AccountTypesResponse(name: $name, specficationName: $specficationName, subSpecificationName: $subSpecificationName, description: $description, template: $template, id: $id, isValid: $isValid)';
  }

  
}
