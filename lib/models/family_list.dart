import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';
import 'family.dart';

part 'family_list.g.dart';

abstract class FamilyList implements Built<FamilyList, FamilyListBuilder> {
  factory FamilyList([void Function(FamilyListBuilder) updates]) = _$FamilyList;

  FamilyList._();

  BuiltList<Family> get familyList;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(FamilyList.serializer, this) as Map<String, dynamic>;
  }

  static FamilyList? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(FamilyList.serializer, json);
  }

  static Serializer<FamilyList> get serializer => _$familyListSerializer;
}
