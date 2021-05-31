import 'package:built_collection/built_collection.dart';

import '../api/utils/api_response.dart';
import '../models/chore.dart';
import '../models/family.dart';
import '../utils/log.dart';
import 'family_repository.dart';

class ChoreRepository {
  ChoreRepository(
    this.familyRepository,
  );

  final FamilyRepository familyRepository;

  Stream<BuiltList<Chore>?> getChores(String familyId) {
    return familyRepository.getFamily(familyId).asyncMap((event) {
      return event.data()?.chores;
    });
  }

  Stream<Chore?> getChore(String familyId, String choreId) {
    return familyRepository.getFamily(familyId).asyncMap((event) {
      return event.data()?.chores.firstWhere((chore) => chore.id == choreId);
    });
  }

  Future<ApiResponse> addChore(Chore chore, String familyId) async {
    try {
      logger(chore);
      final _familyDocument = await familyRepository.familyDocument(familyId);
      final family = await _familyDocument
          .withConverter<Family>(
              fromFirestore: (snapshot, _) => Family.fromJson(snapshot.data()!) ?? Family(),
              toFirestore: (family, _) => family.toJson())
          .get();
      if (family.data() != null) {
        final familyChoreList = family.data()?.chores.asList() ?? [];
        final choreList = [...familyChoreList, chore];

        final familyRebuild = family.data()?.rebuild(
              (b) => b..chores = choreList.toBuiltList().toBuilder(),
            );
        return familyRepository.addFamily(familyRebuild!);
      } else {
        return ApiResponse.error('Couldn\'t add Chore because family doesn\'t exist.');
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
