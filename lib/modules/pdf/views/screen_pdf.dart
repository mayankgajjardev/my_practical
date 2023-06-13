import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/pdf/controller/controller_pdf.dart';
import 'package:flutter_practical/utils/constants/app_constants.dart';
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
        title: const Text("View PDF"),
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
                      : RefreshIndicator(
                          onRefresh: () async {
                            await pdfCtrl.fetchedPdf();
                          },
                          child: GridView.builder(
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
                                          AppConstans.imdPdf,
                                          height: 120,
                                          width: 100,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            pdf['name'],
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
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
          ),
          Obx(
            () => pdfCtrl.isUploading.value
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppHelper.loader(),
                  )
                : TextButton(
                    onPressed: () {
                      pdfCtrl.pickFile();
                    },
                    child: const Text("Add Pdf"),
                  ),
          )
        ],
      ),
    );
  }
}
