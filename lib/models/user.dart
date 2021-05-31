import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import '../serializers/serializers.dart';
import 'family.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  factory User([void Function(UserBuilder) updates]) = _$User;

  User._();

  String? get name;

  String? get id;

  String? get image;

  String? get lastName;

  String? get userName;

  DateTime? get dateOfBirth;

  BuiltList<Family>? get families;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(User.serializer, this) as Map<String, dynamic>;
  }

  static User? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(User.serializer, json);
  }

  static Serializer<User> get serializer => _$userSerializer;
}
