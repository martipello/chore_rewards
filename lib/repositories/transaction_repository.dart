import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/utils/api_response.dart';
import '../models/piggy_bank.dart';
import '../models/transaction.dart' as t;
import '../utils/constants.dart';
import '../utils/log.dart';
import 'family_members_repository.dart';

class TransactionRepository {
  TransactionRepository(
    this.sharedPreferences,
    this.firebaseFirestore,
    this.familyMembersRepository,
  );

  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firebaseFirestore;
  final FamilyMembersRepository familyMembersRepository;

  Future<CollectionReference> _transactionCollection(String familyId) async {
    final userId = sharedPreferences.getString(Constants.USER_ID);
    return firebaseFirestore.collection('/users/$userId/families/$familyId/members/$userId/transactions');
  }

  Stream<QuerySnapshot<t.Transaction>> getTransactions(String familyId) async* {
    final transactionsCollection = await _transactionCollection(familyId);
    yield* transactionsCollection
        .withConverter<t.Transaction>(
          fromFirestore: (snapshots, _) => t.Transaction.fromJson(snapshots.data()!) ?? t.Transaction(),
          toFirestore: (transaction, _) => transaction.toJson(),
        )
        .snapshots();
  }

  Future<ApiResponse> addTransaction(t.Transaction transaction, String familyId) async {
    try {
      logger(transaction);
      final transactionCollection = await _transactionCollection(familyId);
      transactionCollection.doc(transaction.id).set(transaction.toJson());
      _updatePiggyBank(transaction.reward!, familyId);
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse> _updatePiggyBank(
    double reward,
    String familyId,
  ) async {
    try {
      final familyMemberDocument = await familyMembersRepository.getFamilyMember(familyId);
      if (familyMemberDocument.data()?.piggyBank != null) {
        final piggyBank = familyMemberDocument.data()!.piggyBank!;
        familyMembersRepository.updateFamilyMember(
            familyMemberDocument.data()!.rebuild(
                  (b) => b..piggyBank = PiggyBank((b) => b..balance = piggyBank.balance ?? 0 + reward).toBuilder(),
                ),
            familyId);
      } else {
        familyMembersRepository.updateFamilyMember(
            familyMemberDocument.data()!.rebuild(
                  (b) => b..piggyBank = PiggyBank((b) => b..balance = reward).toBuilder(),
                ),
            familyId);
      }
      return ApiResponse.completed(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
