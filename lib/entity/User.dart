import 'package:instagram_clone/entity/Post.dart';
// User.dart

class User {
  String id;
  String userName;
  String email;
  String fullName;
  String bio;
  List<User> followers;
  List<User> following;
  List<User> request;
  String password;
  List<Post> savedPost;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.fullName,
    required this.bio,
    required this.followers,
    required this.following,
    required this.request,
    required this.password,
    required this.savedPost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'fullName': fullName,
      'bio': bio,
      'followers': followers,
      'following': following,
      'request': request,
      'password': password,
      'savedPost': savedPost,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      bio: map['bio'] as String,
      followers: List<User>.from(map['followers'].map((item) => User.fromMap(item))),
      following: List<User>.from(map['following'].map((item) => User.fromMap(item))),
      request: List<User>.from(map['request'].map((item) => User.fromMap(item))),
      password: map['password'] as String,
      savedPost: List<Post>.from(map['savedPost'].map((item) => Post.fromMap(item))),
    );
  }
}
