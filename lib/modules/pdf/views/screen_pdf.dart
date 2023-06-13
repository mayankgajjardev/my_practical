import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/pdf/controller/controller_pdf.dart';
import 'package:flutter_practical/utils/helper/app_helper.dart';
import 'package:get/get.dart';

class ScreenPdf extends StatefulWidget {
  const ScreenPdf({super.key});

  @override
  State<ScreenPdf> createState() => _ScreenPdfState();
}

class _ScreenPdfState extends State<ScreenPdf> {
  final pdfCtrl = Get.find<ControllerPdf>();

  @override
  void initState() {
    super.initState();
    pdfCtrl.fetchedPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pdfs"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => pdfCtrl.isLoading.value
                  ? Center(
                      child: AppHelper.loader(),
                    )
                  : pdfCtrl.allPdfs.isEmpty
                      ? const Center(
                          child: Text("No pdf found"),
                        )
                      : GridView.builder(
                          itemCount: pdfCtrl.allPdfs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            var pdf = pdfCtrl.allPdfs[index];
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: InkWell(
                                onTap: () {
                                  pdfCtrl.openPDF(pdf['url']);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Adobe_Acrobat_DC_logo_2020.svg/640px-Adobe_Acrobat_DC_logo_2020.svg.png",
                                        height: 120,
                                        width: 100,
                                      ),
                                      Text(
                                        pdf['name'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
          TextButton(
            onPressed: () {
              pdfCtrl.pickFile();
            },
            child: const Text("Add Pdf"),
          )
        ],
      ),
    );
  }
}
