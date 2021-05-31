import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers/serializers.dart';

part 'comment.g.dart';

abstract class Comment implements Built<Comment, CommentBuilder> {
  factory Comment([void Function(CommentBuilder) updates]) = _$Comment;

  Comment._();

  String? get senderId;

  DateTime? get sentDate;

  String? get message;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Comment.serializer, this) as Map<String, dynamic>;
  }

  static Comment? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Comment.serializer, json);
  }

  static Serializer<Comment> get serializer => _$commentSerializer;
}
