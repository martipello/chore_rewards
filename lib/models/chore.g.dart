// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Chore> _$choreSerializer = new _$ChoreSerializer();

class _$ChoreSerializer implements StructuredSerializer<Chore> {
  @override
  final Iterable<Type> types = const [Chore, _$Chore];
  @override
  final String wireName = 'Chore';

  @override
  Iterable<Object?> serialize(Serializers serializers, Chore object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'comments',
      serializers.serialize(object.comments,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Comment)])),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.reward;
    if (value != null) {
      result
        ..add('reward')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.addedDate;
    if (value != null) {
      result
        ..add('addedDate')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.completedDate;
    if (value != null) {
      result
        ..add('completedDate')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.rewardedDate;
    if (value != null) {
      result
        ..add('rewardedDate')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.expiryDate;
    if (value != null) {
      result
        ..add('expiryDate')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.allocation;
    if (value != null) {
      result
        ..add('allocation')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(Allocation)));
    }
    value = object.allocatedToFamilyMember;
    if (value != null) {
      result
        ..add('allocatedToFamilyMember')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(AllocatedFamilyMember)));
    }
    value = object.createdBy;
    if (value != null) {
      result
        ..add('createdBy')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(AllocatedFamilyMember)));
    }
    return result;
  }

  @override
  Chore deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChoreBuilder();

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
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reward':
          result.reward = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'addedDate':
          result.addedDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'completedDate':
          result.completedDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'rewardedDate':
          result.rewardedDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'expiryDate':
          result.expiryDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'allocation':
          result.allocation = serializers.deserialize(value,
              specifiedType: const FullType(Allocation)) as Allocation;
          break;
        case 'comments':
          result.comments.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Comment)]))!
              as BuiltList<Object>);
          break;
        case 'allocatedToFamilyMember':
          result.allocatedToFamilyMember.replace(serializers.deserialize(value,
                  specifiedType: const FullType(AllocatedFamilyMember))!
              as AllocatedFamilyMember);
          break;
        case 'createdBy':
          result.createdBy.replace(serializers.deserialize(value,
                  specifiedType: const FullType(AllocatedFamilyMember))!
              as AllocatedFamilyMember);
          break;
      }
    }

    return result.build();
  }
}

class _$Chore extends Chore {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final double? reward;
  @override
  final DateTime? addedDate;
  @override
  final DateTime? completedDate;
  @override
  final DateTime? rewardedDate;
  @override
  final DateTime? expiryDate;
  @override
  final String? image;
  @override
  final Allocation? allocation;
  @override
  final BuiltList<Comment> comments;
  @override
  final AllocatedFamilyMember? allocatedToFamilyMember;
  @override
  final AllocatedFamilyMember? createdBy;

  factory _$Chore([void Function(ChoreBuilder)? updates]) =>
      (new ChoreBuilder()..update(updates)).build();

  _$Chore._(
      {this.id,
      this.title,
      this.description,
      this.reward,
      this.addedDate,
      this.completedDate,
      this.rewardedDate,
      this.expiryDate,
      this.image,
      this.allocation,
      required this.comments,
      this.allocatedToFamilyMember,
      this.createdBy})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(comments, 'Chore', 'comments');
  }

  @override
  Chore rebuild(void Function(ChoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChoreBuilder toBuilder() => new ChoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Chore &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        reward == other.reward &&
        addedDate == other.addedDate &&
        completedDate == other.completedDate &&
        rewardedDate == other.rewardedDate &&
        expiryDate == other.expiryDate &&
        image == other.image &&
        allocation == other.allocation &&
        comments == other.comments &&
        allocatedToFamilyMember == other.allocatedToFamilyMember &&
        createdBy == other.createdBy;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc($jc(0, id.hashCode),
                                                    title.hashCode),
                                                description.hashCode),
                                            reward.hashCode),
                                        addedDate.hashCode),
                                    completedDate.hashCode),
                                rewardedDate.hashCode),
                            expiryDate.hashCode),
                        image.hashCode),
                    allocation.hashCode),
                comments.hashCode),
            allocatedToFamilyMember.hashCode),
        createdBy.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Chore')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('reward', reward)
          ..add('addedDate', addedDate)
          ..add('completedDate', completedDate)
          ..add('rewardedDate', rewardedDate)
          ..add('expiryDate', expiryDate)
          ..add('image', image)
          ..add('allocation', allocation)
          ..add('comments', comments)
          ..add('allocatedToFamilyMember', allocatedToFamilyMember)
          ..add('createdBy', createdBy))
        .toString();
  }
}

class ChoreBuilder implements Builder<Chore, ChoreBuilder> {
  _$Chore? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  double? _reward;
  double? get reward => _$this._reward;
  set reward(double? reward) => _$this._reward = reward;

  DateTime? _addedDate;
  DateTime? get addedDate => _$this._addedDate;
  set addedDate(DateTime? addedDate) => _$this._addedDate = addedDate;

  DateTime? _completedDate;
  DateTime? get completedDate => _$this._completedDate;
  set completedDate(DateTime? completedDate) =>
      _$this._completedDate = completedDate;

  DateTime? _rewardedDate;
  DateTime? get rewardedDate => _$this._rewardedDate;
  set rewardedDate(DateTime? rewardedDate) =>
      _$this._rewardedDate = rewardedDate;

  DateTime? _expiryDate;
  DateTime? get expiryDate => _$this._expiryDate;
  set expiryDate(DateTime? expiryDate) => _$this._expiryDate = expiryDate;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  Allocation? _allocation;
  Allocation? get allocation => _$this._allocation;
  set allocation(Allocation? allocation) => _$this._allocation = allocation;

  ListBuilder<Comment>? _comments;
  ListBuilder<Comment> get comments =>
      _$this._comments ??= new ListBuilder<Comment>();
  set comments(ListBuilder<Comment>? comments) => _$this._comments = comments;

  AllocatedFamilyMemberBuilder? _allocatedToFamilyMember;
  AllocatedFamilyMemberBuilder get allocatedToFamilyMember =>
      _$this._allocatedToFamilyMember ??= new AllocatedFamilyMemberBuilder();
  set allocatedToFamilyMember(
          AllocatedFamilyMemberBuilder? allocatedToFamilyMember) =>
      _$this._allocatedToFamilyMember = allocatedToFamilyMember;

  AllocatedFamilyMemberBuilder? _createdBy;
  AllocatedFamilyMemberBuilder get createdBy =>
      _$this._createdBy ??= new AllocatedFamilyMemberBuilder();
  set createdBy(AllocatedFamilyMemberBuilder? createdBy) =>
      _$this._createdBy = createdBy;

  ChoreBuilder();

  ChoreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _reward = $v.reward;
      _addedDate = $v.addedDate;
      _completedDate = $v.completedDate;
      _rewardedDate = $v.rewardedDate;
      _expiryDate = $v.expiryDate;
      _image = $v.image;
      _allocation = $v.allocation;
      _comments = $v.comments.toBuilder();
      _allocatedToFamilyMember = $v.allocatedToFamilyMember?.toBuilder();
      _createdBy = $v.createdBy?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Chore other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Chore;
  }

  @override
  void update(void Function(ChoreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Chore build() {
    _$Chore _$result;
    try {
      _$result = _$v ??
          new _$Chore._(
              id: id,
              title: title,
              description: description,
              reward: reward,
              addedDate: addedDate,
              completedDate: completedDate,
              rewardedDate: rewardedDate,
              expiryDate: expiryDate,
              image: image,
              allocation: allocation,
              comments: comments.build(),
              allocatedToFamilyMember: _allocatedToFamilyMember?.build(),
              createdBy: _createdBy?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'comments';
        comments.build();
        _$failedField = 'allocatedToFamilyMember';
        _allocatedToFamilyMember?.build();
        _$failedField = 'createdBy';
        _createdBy?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Chore', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
