// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      userName: fields[1] as String,
      email: fields[2] as String,
      fullName: fields[3] as String,
      bio: fields[4] as String,
      followers: (fields[7] as List).cast<String>(),
      following: (fields[8] as List).cast<String>(),
      request: (fields[9] as List).cast<String>(),
      password: fields[5] as String,
      savedPost: (fields[10] as List).cast<String>(),
      imageUrl: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.followers)
      ..writeByte(8)
      ..write(obj.following)
      ..writeByte(9)
      ..write(obj.request)
      ..writeByte(10)
      ..write(obj.savedPost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
