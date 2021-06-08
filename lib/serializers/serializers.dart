import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../models/allocated_family_member.dart';
import '../models/allocation.dart';
import '../models/authentication_request.dart';
import '../models/chore.dart';
import '../models/comment.dart';
import '../models/family.dart';
import '../models/family_member.dart';
import '../models/family_member_type.dart';
import '../models/piggy_bank.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../models/user.dart';
import 'date_time_serializer.dart';

part 'serializers.g.dart';

@SerializersFor([
  AuthenticationRequest,
  User,
  Chore,
  Family,
  AllocatedFamilyMember,
  FamilyMember,
  FamilyMemberType,
  PiggyBank,
  Transaction,
  Comment,
  Allocation,
  TransactionType,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
