import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan/Vekaletname/Vekaletname_Controller/Vekaletname_Controller.dart';
import 'package:get/get.dart';

class RecognizerScreen extends StatelessWidget {
  final List<File> images;
  final VekaletnameController vekaletnameController =
      Get.put(VekaletnameController());

  RecognizerScreen(this.images) {
    if (images.isNotEmpty) {
      vekaletnameController.processVekaletnameImages(images);
    } else {
      Get.snackbar('Hata', 'Herhangi bir belge bulunamadı.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Vekaletname Tanıma'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (images.isNotEmpty) ...[
                for (int index = 0; index < images.length; index++)
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(images[index]),
                        ),
                      ),
                      Obx(() => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tanımlanan Metinler',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy,
                                            color: Colors.white),
                                        onPressed: () {
                                          if (vekaletnameController
                                              .recognizedTexts.isNotEmpty) {
                                            Clipboard.setData(ClipboardData(
                                                text: vekaletnameController
                                                    .recognizedTexts[index]));
                                            Get.snackbar('Kopyalandı',
                                                'Metin kopyalandı.',
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white);
                                          } else {
                                            Get.snackbar('Hata',
                                                'Herhangi bir metin bulunamadı.',
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    vekaletnameController
                                                .recognizedTexts.isNotEmpty &&
                                            vekaletnameController
                                                    .recognizedTexts.length >
                                                index
                                        ? vekaletnameController
                                            .recognizedTexts[index]
                                        : "Metin tanımlanıyor, lütfen bekleyin...",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 20),
                    ],
                  ),
              ] else
                const Text(
                  'Herhangi bir belge bulunamadı.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ElevatedButton(
                onPressed: () async {
                  if (images.isNotEmpty) {
                    await vekaletnameController.saveVekaletnameData();
                    Get.offAllNamed('/'); // Anasayfaya yönlendir
                  } else {
                    Get.snackbar('Hata', 'Herhangi bir belge bulunamadı.',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                child: const Text('Bu Fotoğrafları Kullan'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
