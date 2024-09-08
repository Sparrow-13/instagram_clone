import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:instagram_clone/utils/log_utility.dart';

part 'user.g.dart'; // Add this line for the generated code

@HiveType(typeId: 0) // Set a unique type ID for this class
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String fullName;

  @HiveField(4)
  String bio;

  @HiveField(5)
  String password;

  @HiveField(6)
  String imageUrl;

  @HiveField(7)
  List<String> followers;

  @HiveField(8)
  List<String> following;

  @HiveField(9)
  List<String> request;

  @HiveField(10)
  List<String> savedPost;

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
    required this.imageUrl,
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
      'imageUrl': imageUrl,
      'savedPost': savedPost,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      request: List<String>.from(map['request'] ?? []),
      password: map['password'] as String? ?? '',
      savedPost: List<String>.from(map['savedPost'] ?? []),
    );
  }

  factory User.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    LoggingService.logStatement(data.toString());
    List<String> convertReferencesToIds(List<dynamic> references) {
      return references.map((ref) {
        if (ref is DocumentReference) {
          return ref.id; // Get the document ID from the reference
        } else {
          return ''; // Handle cases where the reference is not DocumentReference
        }
      }).toList();
    }
    return User(
      id: data['id'] as String,
      userName: data['userName'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      bio: data['bio'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      followers: convertReferencesToIds(data['followers'] ?? []),
      following: convertReferencesToIds(data['following'] ?? []),
      request: convertReferencesToIds(data['request'] ?? []),
      password: data['password'] ?? '',
      savedPost: convertReferencesToIds(data['savedPost'] ?? []), // Handle `savedPost` if needed
    );
  }
}
