// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Family> _$familySerializer = new _$FamilySerializer();

class _$FamilySerializer implements StructuredSerializer<Family> {
  @override
  final Iterable<Type> types = const [Family, _$Family];
  @override
  final String wireName = 'Family';

  @override
  Iterable<Object?> serialize(Serializers serializers, Family object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.headOfFamily;
    if (value != null) {
      result
        ..add('headOfFamily')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(FamilyMember)));
    }
    return result;
  }

  @override
  Family deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FamilyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'headOfFamily':
          result.headOfFamily.replace(serializers.deserialize(value,
              specifiedType: const FullType(FamilyMember))! as FamilyMember);
          break;
      }
    }

    return result.build();
  }
}

class _$Family extends Family {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? image;
  @override
  final FamilyMember? headOfFamily;

  factory _$Family([void Function(FamilyBuilder)? updates]) =>
      (new FamilyBuilder()..update(updates)).build();

  _$Family._({this.id, this.name, this.image, this.headOfFamily}) : super._();

  @override
  Family rebuild(void Function(FamilyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FamilyBuilder toBuilder() => new FamilyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Family &&
        id == other.id &&
        name == other.name &&
        image == other.image &&
        headOfFamily == other.headOfFamily;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, id.hashCode), name.hashCode), image.hashCode),
        headOfFamily.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Family')
          ..add('id', id)
          ..add('name', name)
          ..add('image', image)
          ..add('headOfFamily', headOfFamily))
        .toString();
  }
}

class FamilyBuilder implements Builder<Family, FamilyBuilder> {
  _$Family? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  FamilyMemberBuilder? _headOfFamily;
  FamilyMemberBuilder get headOfFamily =>
      _$this._headOfFamily ??= new FamilyMemberBuilder();
  set headOfFamily(FamilyMemberBuilder? headOfFamily) =>
      _$this._headOfFamily = headOfFamily;

  FamilyBuilder();

  FamilyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _image = $v.image;
      _headOfFamily = $v.headOfFamily?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Family other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Family;
  }

  @override
  void update(void Function(FamilyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Family build() {
    _$Family _$result;
    try {
      _$result = _$v ??
          new _$Family._(
              id: id,
              name: name,
              image: image,
              headOfFamily: _headOfFamily?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'headOfFamily';
        _headOfFamily?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Family', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
