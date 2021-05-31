import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/utils/api_response.dart';
import '../../models/allocation.dart';
import '../../models/chore.dart';
import '../../repositories/chore_repository.dart';
import '../../repositories/image_repository.dart';
import '../../utils/log.dart';

class ChoreViewModel {
  ChoreViewModel(this.choreRepository, this.imageRepository);

  final ChoreRepository choreRepository;
  final ImageRepository imageRepository;

  final BehaviorSubject<ApiResponse> saveChoreResult = BehaviorSubject();

  final BehaviorSubject<Chore> choreStream = BehaviorSubject.seeded(Chore());

  Future<String> getFirebaseStorageUrl(String imagePath) {
    return imageRepository.getImageUrlForImagePath(imagePath);
  }

  Stream<BuiltList<Chore>?> getChores(String familyId) {
    return choreRepository.getChores(familyId);
  }

  Future<void> createChore({
    File? imageFile,
    String? imageUrl,
    required String familyId,
  }) async {
    saveChoreResult.add(ApiResponse.loading(null));
    final now = DateTime.now();
    final chore = choreStream.value.rebuild((b) => b
      ..id = '${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}'
      ..addedDate = DateTime.now()
      ..allocation = Allocation.pending);
    if (imageFile != null) {
      final uploadResult = await imageRepository.uploadImage(imageFile, '${chore.id}/$familyId/uploads');
      logger('uploadResult $uploadResult');
      if (uploadResult.status == Status.ERROR) {
        saveChoreResult.add(ApiResponse.error('Uploading image failed.'));
      }
      logger('family before rebuild  $familyId');
      final _choreWithImage = chore.rebuild((b) => b..image = uploadResult.data);
      await _addChore(_choreWithImage, familyId);
    } else {
      await _addChore(chore, familyId);
    }
  }

  Future<void> _addChore(Chore chore, String familyId) async {
    final addChoreResult = await choreRepository.addChore(chore, familyId);
    saveChoreResult.add(addChoreResult);
  }

  void setChoreTitle(String title) {
    final chore = choreStream.value.rebuild((b) => b..title = title);
    choreStream.add(chore);
  }

  void setChoreDescription(String description) {
    final chore = choreStream.value.rebuild((b) => b..description = description);
    choreStream.add(chore);
  }

  void setChoreExpiry(DateTime expiry) {
    final chore = choreStream.value.rebuild((b) => b..expiryDate = expiry);
    choreStream.add(chore);
  }

  void addChoreReward() {
    final chore = choreStream.value;
    final reward = chore.reward ?? 0;
    choreStream.add(chore.rebuild((b) => b..reward = reward + 1));
  }

  void minusChoreReward() {
    final chore = choreStream.value;
    final reward = chore.reward ?? 0;
    if (reward > 0) {
      choreStream.add(chore.rebuild((b) => b..reward = reward - 1));
    }
  }

  void dispose() {
    saveChoreResult.close();
    choreStream.close();
  }
}
