import 'dart:convert';

class VoteResponse {
  String itemId;
  bool status;
  VoteResponse({
    this.itemId,
    this.status,
  });

  VoteResponse copyWith({
    String itemId,
    bool status,
  }) {
    return VoteResponse(
      itemId: itemId ?? this.itemId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'status': status,
    };
  }

  factory VoteResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return VoteResponse(
      itemId: map['itemId'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VoteResponse.fromJson(String source) => VoteResponse.fromMap(json.decode(source));

  @override
  String toString() => 'VoteResponse(itemId: $itemId, status: $status)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is VoteResponse &&
      o.itemId == itemId &&
      o.status == status;
  }

  @override
  int get hashCode => itemId.hashCode ^ status.hashCode;
}
