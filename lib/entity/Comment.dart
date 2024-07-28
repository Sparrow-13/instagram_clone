import 'Like.dart';

class Comment {
  String id;
  String type;
  String typeId;
  String comment;
  List<Comment> replies;
  List<Like> likes;

//<editor-fold desc="Data Methods">
  Comment({
    required this.id,
    required this.type,
    required this.typeId,
    required this.comment,
    required this.replies,
    required this.likes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          typeId == other.typeId &&
          comment == other.comment &&
          replies == other.replies &&
          likes == other.likes);

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      typeId.hashCode ^
      comment.hashCode ^
      replies.hashCode ^
      likes.hashCode;

  @override
  String toString() {
    return 'Comment{ id: $id, type: $type, typeId: $typeId, comment: $comment, replies: $replies, likes: $likes,}';
  }

  Comment copyWith({
    String? id,
    String? type,
    String? typeId,
    String? comment,
    List<Comment>? replies,
    List<Like>? likes,
  }) {
    return Comment(
      id: id ?? this.id,
      type: type ?? this.type,
      typeId: typeId ?? this.typeId,
      comment: comment ?? this.comment,
      replies: replies ?? this.replies,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'typeId': typeId,
      'comment': comment,
      'replies': replies,
      'likes': likes,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      type: map['type'] as String,
      typeId: map['typeId'] as String,
      comment: map['comment'] as String,
      replies: map['replies'] as List<Comment>,
      likes: map['likes'] as List<Like>,
    );
  }

//</editor-fold>
}
