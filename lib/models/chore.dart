import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';
import 'allocated_family_member.dart';
import 'allocation.dart';
import 'comment.dart';

part 'chore.g.dart';

abstract class Chore implements Built<Chore, ChoreBuilder> {
  factory Chore([void Function(ChoreBuilder) updates]) = _$Chore;

  Chore._();

  String? get id;

  String? get title;

  String? get description;

  double? get reward;

  DateTime? get addedDate;

  DateTime? get completedDate;

  DateTime? get expiryDate;

  String? get image;

  Allocation? get allocation;

  BuiltList<Comment> get comments;

  AllocatedFamilyMember? get allocatedToFamilyMember;

  AllocatedFamilyMember? get createdBy;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Chore.serializer, this) as Map<String, dynamic>;
  }

  static Chore? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Chore.serializer, json);
  }

  static Serializer<Chore> get serializer => _$choreSerializer;
}
