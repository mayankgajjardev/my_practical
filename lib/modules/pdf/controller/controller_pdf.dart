import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/pdf/views/screen_pdf_view.dart';
import 'package:flutter_practical/utils/constants/app_constants.dart';
import 'package:get/get.dart';

class ControllerPdf extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var isLoading = false.obs;
  var isUploading = false.obs;
  var allPdfs = [].obs;

  // Upload Pdf
  Future<String> uploadPdf(String filePath) async {
    String fileName = filePath.split('/').last;
    final ref = FirebaseStorage.instance.ref().child('pdfs').child(fileName);
    await ref.putFile(File(filePath), SettableMetadata(contentType: 'pdf'));
    String downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  Future<void> openPDF(String filePath) async {
    debugPrint("Mayank :: FIle Path :: $filePath");
    Reference ref = _storage.ref('pdfs/$filePath');
    String url = await ref.getDownloadURL();
    debugPrint("Mayank :: Final Url :: $url");
    Get.to(() => ScreenPdfView(pdfUrl: url));
  }

  // Pick File
  void pickFile() async {
    isUploading(true);
    try {
      final pickedFile = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);

      if (pickedFile != null) {
        String filePath = pickedFile.files.single.path!;
        final downloadLink = await uploadPdf(filePath);

        await _firestore.collection(AppConstans.pdfsCollection).add({
          "name": pickedFile.files.single.name,
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
