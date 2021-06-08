// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FamilyMember> _$familyMemberSerializer =
    new _$FamilyMemberSerializer();

class _$FamilyMemberSerializer implements StructuredSerializer<FamilyMember> {
  @override
  final Iterable<Type> types = const [FamilyMember, _$FamilyMember];
  @override
  final String wireName = 'FamilyMember';

  @override
  Iterable<Object?> serialize(Serializers serializers, FamilyMember object,
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
    value = object.dateOfBirth;
    if (value != null) {
      result
        ..add('dateOfBirth')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.piggyBank;
    if (value != null) {
      result
        ..add('piggyBank')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(PiggyBank)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.familyMemberType;
    if (value != null) {
      result
        ..add('familyMemberType')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(FamilyMemberType)));
    }
    return result;
  }

  @override
  FamilyMember deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FamilyMemberBuilder();

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
        case 'dateOfBirth':
          result.dateOfBirth = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'piggyBank':
          result.piggyBank.replace(serializers.deserialize(value,
              specifiedType: const FullType(PiggyBank))! as PiggyBank);
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'familyMemberType':
          result.familyMemberType = serializers.deserialize(value,
                  specifiedType: const FullType(FamilyMemberType))
              as FamilyMemberType;
          break;
      }
    }

    return result.build();
  }
}

class _$FamilyMember extends FamilyMember {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? lastName;
  @override
  final DateTime? dateOfBirth;
  @override
  final PiggyBank? piggyBank;
  @override
  final String? image;
  @override
  final FamilyMemberType? familyMemberType;

  factory _$FamilyMember([void Function(FamilyMemberBuilder)? updates]) =>
      (new FamilyMemberBuilder()..update(updates)).build();

  _$FamilyMember._(
      {this.id,
      this.name,
      this.lastName,
      this.dateOfBirth,
      this.piggyBank,
      this.image,
      this.familyMemberType})
      : super._();

  @override
  FamilyMember rebuild(void Function(FamilyMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FamilyMemberBuilder toBuilder() => new FamilyMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyMember &&
        id == other.id &&
        name == other.name &&
        lastName == other.lastName &&
        dateOfBirth == other.dateOfBirth &&
        piggyBank == other.piggyBank &&
        image == other.image &&
        familyMemberType == other.familyMemberType;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), name.hashCode),
                        lastName.hashCode),
                    dateOfBirth.hashCode),
                piggyBank.hashCode),
            image.hashCode),
        familyMemberType.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FamilyMember')
          ..add('id', id)
          ..add('name', name)
          ..add('lastName', lastName)
          ..add('dateOfBirth', dateOfBirth)
          ..add('piggyBank', piggyBank)
          ..add('image', image)
          ..add('familyMemberType', familyMemberType))
        .toString();
  }
}

class FamilyMemberBuilder
    implements Builder<FamilyMember, FamilyMemberBuilder> {
  _$FamilyMember? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(DateTime? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  PiggyBankBuilder? _piggyBank;
  PiggyBankBuilder get piggyBank =>
      _$this._piggyBank ??= new PiggyBankBuilder();
  set piggyBank(PiggyBankBuilder? piggyBank) => _$this._piggyBank = piggyBank;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  FamilyMemberType? _familyMemberType;
  FamilyMemberType? get familyMemberType => _$this._familyMemberType;
  set familyMemberType(FamilyMemberType? familyMemberType) =>
      _$this._familyMemberType = familyMemberType;

  FamilyMemberBuilder();

  FamilyMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _lastName = $v.lastName;
      _dateOfBirth = $v.dateOfBirth;
      _piggyBank = $v.piggyBank?.toBuilder();
      _image = $v.image;
      _familyMemberType = $v.familyMemberType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyMember other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FamilyMember;
  }

  @override
  void update(void Function(FamilyMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FamilyMember build() {
    _$FamilyMember _$result;
    try {
      _$result = _$v ??
          new _$FamilyMember._(
              id: id,
              name: name,
              lastName: lastName,
              dateOfBirth: dateOfBirth,
              piggyBank: _piggyBank?.build(),
              image: image,
              familyMemberType: familyMemberType);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'piggyBank';
        _piggyBank?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FamilyMember', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
