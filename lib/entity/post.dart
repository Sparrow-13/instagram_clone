import 'comment.dart';
import 'like.dart';
import 'user.dart';

class Post {
  String id;
  String postByUser;
  String sourceUrl;
  String caption;
  List<User> taggedPeople;
  List<Like> likes;
  List<Comment> comments;
  DateTime createdDate;

//<editor-fold desc="Data Methods">
  Post({
    required this.id,
    required this.postByUser,
    required this.sourceUrl,
    required this.caption,
    required this.taggedPeople,
    required this.likes,
    required this.comments,
    required this.createdDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          postByUser == other.postByUser &&
          sourceUrl == other.sourceUrl &&
          caption == other.caption &&
          taggedPeople == other.taggedPeople &&
          likes == other.likes &&
          comments == other.comments &&
          createdDate == other.createdDate);

  @override
  int get hashCode =>
      id.hashCode ^
      postByUser.hashCode ^
      sourceUrl.hashCode ^
      caption.hashCode ^
      taggedPeople.hashCode ^
      likes.hashCode ^
      comments.hashCode ^
      createdDate.hashCode;

  @override
  String toString() {
    return 'Post{ id: $id, postByUser: $postByUser, sourceUrl: $sourceUrl, caption: $caption, taggedPeople: $taggedPeople, likes: $likes, comments: $comments, createdDate: $createdDate,}';
  }

  Post copyWith({
    String? id,
    String? postByUser,
    String? sourceUrl,
    String? caption,
    List<User>? taggedPeople,
    List<Like>? likes,
    List<Comment>? comments,
    DateTime? createdDate,
  }) {
    return Post(
      id: id ?? this.id,
      postByUser: postByUser ?? this.postByUser,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      caption: caption ?? this.caption,
      taggedPeople: taggedPeople ?? this.taggedPeople,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postByUser': postByUser,
      'sourceUrl': sourceUrl,
      'caption': caption,
      'taggedPeople': taggedPeople,
      'likes': likes,
      'comments': comments,
      'createdDate': createdDate,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      postByUser: map['postByUser'] as String,
      sourceUrl: map['sourceUrl'] as String,
      caption: map['caption'] as String,
      taggedPeople: map['taggedPeople'] as List<User>,
      likes: map['likes'] as List<Like>,
      comments: map['comments'] as List<Comment>,
      createdDate: map['createdDate'] as DateTime,
    );
  }

//</editor-fold>
}
