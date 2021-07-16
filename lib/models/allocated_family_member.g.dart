// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocated_family_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AllocatedFamilyMember> _$allocatedFamilyMemberSerializer =
    new _$AllocatedFamilyMemberSerializer();

class _$AllocatedFamilyMemberSerializer
    implements StructuredSerializer<AllocatedFamilyMember> {
  @override
  final Iterable<Type> types = const [
    AllocatedFamilyMember,
    _$AllocatedFamilyMember
  ];
  @override
  final String wireName = 'AllocatedFamilyMember';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, AllocatedFamilyMember object,
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
    value = object.lastName;
    if (value != null) {
      result
        ..add('lastName')
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
    value = object.balance;
    if (value != null) {
      result
        ..add('balance')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  AllocatedFamilyMember deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AllocatedFamilyMemberBuilder();

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
        case 'lastName':
          result.lastName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'balance':
          result.balance = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$AllocatedFamilyMember extends AllocatedFamilyMember {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? lastName;
  @override
  final String? image;
  @override
  final double? balance;

  factory _$AllocatedFamilyMember(
          [void Function(AllocatedFamilyMemberBuilder)? updates]) =>
      (new AllocatedFamilyMemberBuilder()..update(updates)).build();

  _$AllocatedFamilyMember._(
      {this.id, this.name, this.lastName, this.image, this.balance})
      : super._();

  @override
  AllocatedFamilyMember rebuild(
          void Function(AllocatedFamilyMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AllocatedFamilyMemberBuilder toBuilder() =>
      new AllocatedFamilyMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocatedFamilyMember &&
        id == other.id &&
        name == other.name &&
        lastName == other.lastName &&
        image == other.image &&
        balance == other.balance;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), name.hashCode), lastName.hashCode),
            image.hashCode),
        balance.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AllocatedFamilyMember')
          ..add('id', id)
          ..add('name', name)
          ..add('lastName', lastName)
          ..add('image', image)
          ..add('balance', balance))
        .toString();
  }
}

class AllocatedFamilyMemberBuilder
    implements Builder<AllocatedFamilyMember, AllocatedFamilyMemberBuilder> {
  _$AllocatedFamilyMember? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  double? _balance;
  double? get balance => _$this._balance;
  set balance(double? balance) => _$this._balance = balance;

  AllocatedFamilyMemberBuilder();

  AllocatedFamilyMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _lastName = $v.lastName;
      _image = $v.image;
      _balance = $v.balance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocatedFamilyMember other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AllocatedFamilyMember;
  }

  @override
  void update(void Function(AllocatedFamilyMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AllocatedFamilyMember build() {
    final _$result = _$v ??
        new _$AllocatedFamilyMember._(
            id: id,
            name: name,
            lastName: lastName,
            image: image,
            balance: balance);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
