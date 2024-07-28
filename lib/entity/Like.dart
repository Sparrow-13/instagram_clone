import 'dart:ffi';

class Like {
  String id;
  String type;
  String typeId;
  String userId;

//<editor-fold desc="Data Methods">
  Like({
    required this.id,
    required this.type,
    required this.typeId,
    required this.userId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Like &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          typeId == other.typeId &&
          userId == other.userId);

  @override
  int get hashCode =>
      id.hashCode ^ type.hashCode ^ typeId.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'Like{ id: $id, type: $type, typeId: $typeId, liked: $userId,}';
  }

  Like copyWith({
    String? id,
    String? type,
    String? typeId,
    Bool? liked,
  }) {
    return Like(
      id: id ?? this.id,
      type: type ?? this.type,
      typeId: typeId ?? this.typeId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'typeId': typeId,
      'liked': userId,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'] as String,
      type: map['type'] as String,
      typeId: map['typeId'] as String,
      userId: map['userId'] as String,
    );
  }

//</editor-fold>
}
