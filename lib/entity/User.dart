class User {
  String id;
  String userName;
  String email;
  String fullName;
  String bio;
  String password;
  String imageUrl;
  List<String> followers;
  List<String> following;
  List<String> request;
  List<String> savedPost;

  User(
      {required this.id,
      required this.userName,
      required this.email,
      required this.fullName,
      required this.bio,
      required this.followers,
      required this.following,
      required this.request,
      required this.password,
      required this.savedPost,
      required this.imageUrl});

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
      'imageUrl': imageUrl,
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
      imageUrl: map['imageUrl'] as String,
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      request: List<String>.from(map['request']),
      password: map['password'] as String,
      savedPost: List<String>.from(map['savedPost']),
    );
  }
}
