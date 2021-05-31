import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import '../serializers/serializers.dart';

part 'authentication_request.g.dart';

abstract class AuthenticationRequest implements Built<AuthenticationRequest, AuthenticationRequestBuilder> {
  factory AuthenticationRequest([void Function(AuthenticationRequestBuilder) updates]) = _$AuthenticationRequest;

  AuthenticationRequest._();

  String? get email;

  String? get password;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(AuthenticationRequest.serializer, this) as Map<String, dynamic>;
  }

  static AuthenticationRequest? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AuthenticationRequest.serializer, json);
  }

  static Serializer<AuthenticationRequest> get serializer => _$authenticationRequestSerializer;
}
