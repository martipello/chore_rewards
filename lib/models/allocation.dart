import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import '../serializers/serializers.dart';

part 'allocation.g.dart';

class Allocation extends EnumClass {
  const Allocation._(String name) : super(name);

  static const Allocation none = _$none;
  static const Allocation available = _$available;
  static const Allocation allocated = _$allocated;
  static const Allocation completed = _$completed;
  static const Allocation rewarded = _$rewarded;

  static BuiltSet<Allocation> get values => _$allocationValues;
  static Allocation valueOf(String name) => _$allocationValueOf(name);

  String serialize() {
    return serializers.serializeWith(Allocation.serializer, this) as String;
  }

  static Allocation? deserialize(String string) {
    return serializers.deserializeWith(Allocation.serializer, string);
  }

  static Serializer<Allocation> get serializer => _$allocationSerializer;
}
