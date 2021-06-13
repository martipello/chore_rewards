import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/allocated_family_member.dart';
import '../models/family_member.dart';
import '../models/transaction.dart' as t;
import '../models/transaction_type.dart';
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

  final BehaviorSubject<t.Transaction> createTransactionStream = BehaviorSubject.seeded(t.Transaction());

  final BehaviorSubject<ApiResponse> rewardResult = BehaviorSubject();

  Stream<QuerySnapshot<t.Transaction>> getTransactions(String familyId) {
    return piggyBankRepository.getTransactions(familyId);
  }

  void setReward(double? reward) {
    final transaction = createTransactionStream.value.rebuild((b) => b..reward = reward);
    createTransactionStream.add(transaction);
  }

  void addChoreReward() {
    final chore = createTransactionStream.value;
    final reward = chore.reward ?? 0;
    createTransactionStream.add(chore.rebuild((b) => b..reward = reward + 1));
  }

  void minusChoreReward() {
    final chore = createTransactionStream.value;
    final reward = chore.reward ?? 0;
    if (reward > 0) {
      createTransactionStream.add(chore.rebuild((b) => b..reward = reward - 1));
    }
  }

  void setPayee(FamilyMember? familyMember) {
    final transaction =
        createTransactionStream.value.rebuild((b) => b..to = _createdByFamilyMember(familyMember).toBuilder());
    createTransactionStream.add(transaction);
  }

  void setTitle(String? title) {
    final transaction = createTransactionStream.value.rebuild((b) => b..title = title);
    createTransactionStream.add(transaction);
  }

  AllocatedFamilyMember _createdByFamilyMember(FamilyMember? familyMember) {
    return AllocatedFamilyMember((b) => b
      ..id = familyMember?.id
      ..name = familyMember?.name
      ..lastName = familyMember?.lastName
      ..image = familyMember?.image);
  }

  void addSpendTransaction(
    String familyId,
    FamilyMember payer,
  ) async {
    addTransaction(familyId, payer, TransactionType.subtraction);
  }

  void addTransaction(
    String familyId,
    FamilyMember payer,
    TransactionType transactionType,
  ) async {
    rewardResult.add(ApiResponse.loading(null));
    final transaction = createTransactionStream.value;
    final _rewardResult = await piggyBankRepository.addTransaction(
        transaction.rebuild(
          (b) => b
            ..transactionType = transactionType
            ..date = DateTime.now()
            ..from = _createdByFamilyMember(payer).toBuilder(),
        ),
        familyId);
    rewardResult.add(_rewardResult);
  }

  void dispose() {
    rewardResult.close();
    createTransactionStream.close();
  }
}
