import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_practical/modules/pdf/views/screen_pdf_view.dart';
import 'package:flutter_practical/utils/constants/app_constants.dart';
import 'package:get/get.dart';

class ControllerPdf extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var isUploading = false.obs;
  var allPdfs = [].obs;

  // Upload Pdf
  Future<String> uploadPdf(String fileName, File file) async {
    final ref = FirebaseStorage.instance.ref().child("pdfs/$fileName");
    final uploadTask = ref.putFile(file, SettableMetadata(contentType: 'pdf'));
    await uploadTask.whenComplete(() {});
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  Future<void> openPDF(String filePath) async {
    try {
      final docFile = await DefaultCacheManager().getSingleFile(filePath);
      Get.to(() => ScreenPdfView(pdfFile: docFile));
    } catch (error) {
      debugPrint("Mayank :: openPDF :: Error :: $error");
    }
  }

  // Pick File
  void pickFile() async {
    isUploading(true);
    try {
      final pickedFile = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);

      if (pickedFile != null) {
        final fileName = pickedFile.files.single.name;
        File file = File(pickedFile.files.single.path!);
        final downloadLink = await uploadPdf(fileName, file);

        await _firestore.collection(AppConstans.pdfsCollection).add({
          "name": fileName,
          "url": downloadLink,
        });
        await fetchedPdf();
        isUploading(false);
        debugPrint("Mayank :: Uploaded Successfully");
      } else {
        isUploading(false);
      }
    } catch (e) {
      isUploading(false);
    }
  }

  // Fetch all pdf
  Future fetchedPdf() async {
    isLoading(true);
    try {
      final allPdf =
          await _firestore.collection(AppConstans.pdfsCollection).get();
      allPdfs.value = allPdf.docs.map((e) => e.data()).toList();
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }
}
