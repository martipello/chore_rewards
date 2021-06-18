import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';
import 'family_member.dart';

part 'family.g.dart';

abstract class Family implements Built<Family, FamilyBuilder> {
  factory Family([void Function(FamilyBuilder) updates]) = _$Family;
  Family._();

  String? get id;
  String? get name;
  String? get image;
  FamilyMember? get headOfFamily;
  String? get pin;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Family.serializer, this) as Map<String, dynamic>;
  }

  static Family? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Family.serializer, json);
  }

  static Serializer<Family> get serializer => _$familySerializer;
}
