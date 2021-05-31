import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../api/utils/api_response.dart';

class ImageRepository {
  ImageRepository(
    this.firebaseStorage,
  );

  final FirebaseStorage firebaseStorage;

  Future<ApiResponse<String>> uploadImage(File imageFile, String storageRef) async {
    try {
      final imageName = DateTime.now().toIso8601String();
      final ref = firebaseStorage.ref(
        '$storageRef/$imageName.png',
      );
      final result = await ref.putFile(imageFile);
      if (result.state == TaskState.error) {
        return ApiResponse.error('Error uploading file');
      }
      return ApiResponse.completed('$storageRef/$imageName.png');
    } on FirebaseException catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<String> getImageUrlForImagePath(String imagePath) async {
    if (imagePath.isNotEmpty) {
      final storageRef = firebaseStorage.ref(imagePath);
      return storageRef.getDownloadURL();
    } else {
      return Future.value('');
    }
  }
}
