import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/modules/users/views/screen_users.dart';
import 'package:flutter_practical/utils/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ControllerUser extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final authCtrl = Get.find<ControllerAuth>();
  var isLoading = false.obs;
  var isFetchLoading = false.obs;

  var selectedImage = XFile('').obs;
  var users = [].obs;

  void pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    selectedImage.value = image ?? XFile('');
  }

  // Upload Image To Storage
  Future<String?> uploadImageToStorage(String userId, XFile imageFile) async {
    try {
      Reference storageRef = _storage.ref().child('profile_images/$userId');
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Mayank :: uploadImageToStorage :: Error :: ${e.toString()}");
      return null;
    }
  }

  // Add User With Image
  Future<void> addUserWithImage(String name, String mobileNumber, String dob,
      String age, XFile imageFile) async {
    isLoading(true);
    var uuid = const Uuid();

    try {
      User? user = authCtrl.currentUser;
      if (user != null) {
        String? imageUrl = await uploadImageToStorage(uuid.v4(), imageFile);

        await _firestore.collection(AppConstans.usersCollection).doc().set({
          "user_id": uuid.v4(),
          "name": name,
          "mobile_number": mobileNumber,
          "dob": dob,
          "age": age,
          "image_path": imageUrl ?? "https://picsum.photos/200",
        });
        isLoading(false);
        Get.back();
        fetchUsers();
      }
    } catch (e) {
      debugPrint("Mayank :: addUserWithImage :: Error :: ${e.toString()}");
      isLoading(false);
    }
  }

  Future<void> updateUser(String uid, String name, String mobileNumber,
      String dob, String age, XFile imageFile) async {
    isLoading(true);

    try {
      User? user = authCtrl.currentUser;
      if (user != null) {
        final CollectionReference collection =
            FirebaseFirestore.instance.collection(AppConstans.usersCollection);
        final QuerySnapshot snapshot =
            await collection.where("user_id", isEqualTo: uid).get();

        for (final DocumentSnapshot doc in snapshot.docs) {
          debugPrint(
              "Mayank :: Photod :: ${doc['image_path']} &&&&&&&& ${imageFile.path.toString()}");
          if (doc['image_path'].toString() != imageFile.path.toString()) {
            String? imageUrl = await uploadImageToStorage(uid, imageFile);
            await doc.reference.update({
              "name": name,
              "mobile_number": mobileNumber,
              "dob": dob,
              "age": age,
              "image_path": imageUrl ?? "https://picsum.photos/200",
            });
          } else {
            await doc.reference.update({
              "name": name,
              "mobile_number": mobileNumber,
              "dob": dob,
              "age": age,
            });
          }
        }
        isLoading(false);
        Get.offAll(() => const ScreenUsers());
        fetchUsers();
      }
    } catch (e) {
      debugPrint("Mayank :: addUserWithImage :: Error :: ${e.toString()}");
      isLoading(false);
    }
  }

  // Fetch Users
  Future fetchUsers() async {
    isFetchLoading(true);
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection(AppConstans.usersCollection).get();
      List<Map<String, dynamic>> fetchedUser =
          snapshot.docs.map((doc) => doc.data()).toList();
      users.value = fetchedUser;
      isFetchLoading(false);
    } catch (e) {
      debugPrint("Mayank :: Error :: ${e.toString()}");
      users.value = [];
      isFetchLoading(false);
    }
  }
}
