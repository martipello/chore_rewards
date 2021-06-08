// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AuthenticationRequest> _$authenticationRequestSerializer =
    new _$AuthenticationRequestSerializer();

class _$AuthenticationRequestSerializer
    implements StructuredSerializer<AuthenticationRequest> {
  @override
  final Iterable<Type> types = const [
    AuthenticationRequest,
    _$AuthenticationRequest
  ];
  @override
  final String wireName = 'AuthenticationRequest';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, AuthenticationRequest object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.password;
    if (value != null) {
      result
        ..add('password')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  AuthenticationRequest deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthenticationRequestBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'password':
          result.password = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthenticationRequest extends AuthenticationRequest {
  @override
  final String? email;
  @override
  final String? password;

  factory _$AuthenticationRequest(
          [void Function(AuthenticationRequestBuilder)? updates]) =>
      (new AuthenticationRequestBuilder()..update(updates)).build();

  _$AuthenticationRequest._({this.email, this.password}) : super._();

  @override
  AuthenticationRequest rebuild(
          void Function(AuthenticationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticationRequestBuilder toBuilder() =>
      new AuthenticationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthenticationRequest &&
        email == other.email &&
        password == other.password;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, email.hashCode), password.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AuthenticationRequest')
          ..add('email', email)
          ..add('password', password))
        .toString();
  }
}

class AuthenticationRequestBuilder
    implements Builder<AuthenticationRequest, AuthenticationRequestBuilder> {
  _$AuthenticationRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  AuthenticationRequestBuilder();

  AuthenticationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthenticationRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthenticationRequest;
  }

  @override
  void update(void Function(AuthenticationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AuthenticationRequest build() {
    final _$result =
        _$v ?? new _$AuthenticationRequest._(email: email, password: password);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
