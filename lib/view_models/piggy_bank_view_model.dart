
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart' as t;
import '../repositories/family_members_repository.dart';
import '../repositories/transaction_repository.dart';

class PiggyBankViewModel {
  PiggyBankViewModel(
      this.familyMemberRepository,
      this.sharedPreferences,
      this.piggyBankRepository,
      );

  final TransactionRepository piggyBankRepository;
  final FamilyMembersRepository familyMemberRepository;
  final SharedPreferences sharedPreferences;

  Stream<QuerySnapshot<t.Transaction>> getTransactions(String familyId) {
    return piggyBankRepository.getTransactions(familyId);
  }

}
