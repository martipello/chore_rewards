// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Comment> _$commentSerializer = new _$CommentSerializer();

class _$CommentSerializer implements StructuredSerializer<Comment> {
  @override
  final Iterable<Type> types = const [Comment, _$Comment];
  @override
  final String wireName = 'Comment';

  @override
  Iterable<Object?> serialize(Serializers serializers, Comment object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.senderId;
    if (value != null) {
      result..add('senderId')..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.sentDate;
    if (value != null) {
      result..add('sentDate')..add(serializers.serialize(value, specifiedType: const FullType(DateTime)));
    }
    value = object.message;
    if (value != null) {
      result..add('message')..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Comment deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommentBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'senderId':
          result.senderId = serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
        case 'sentDate':
          result.sentDate = serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Comment extends Comment {
  @override
  final String? senderId;
  @override
  final DateTime? sentDate;
  @override
  final String? message;

  factory _$Comment([void Function(CommentBuilder)? updates]) => (new CommentBuilder()..update(updates)).build();

  _$Comment._({this.senderId, this.sentDate, this.message}) : super._();

  @override
  Comment rebuild(void Function(CommentBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CommentBuilder toBuilder() => new CommentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Comment && senderId == other.senderId && sentDate == other.sentDate && message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, senderId.hashCode), sentDate.hashCode), message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Comment')
          ..add('senderId', senderId)
          ..add('sentDate', sentDate)
          ..add('message', message))
        .toString();
  }
}

class CommentBuilder implements Builder<Comment, CommentBuilder> {
  _$Comment? _$v;

  String? _senderId;
  String? get senderId => _$this._senderId;
  set senderId(String? senderId) => _$this._senderId = senderId;

  DateTime? _sentDate;
  DateTime? get sentDate => _$this._sentDate;
  set sentDate(DateTime? sentDate) => _$this._sentDate = sentDate;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  CommentBuilder();

  CommentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _senderId = $v.senderId;
      _sentDate = $v.sentDate;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Comment other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Comment;
  }

  @override
  void update(void Function(CommentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Comment build() {
    final _$result = _$v ?? new _$Comment._(senderId: senderId, sentDate: sentDate, message: message);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
