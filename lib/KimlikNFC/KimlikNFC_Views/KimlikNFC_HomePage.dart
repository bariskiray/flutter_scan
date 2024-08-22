import 'package:flutter/material.dart';
import 'package:flutter_scan/KimlikNFC/KimlikNFC_Controller/KimlikNFC_Controller.dart';
import 'package:flutter_scan/KimlikNFC/KimlikNFC_Views/KimlikNFC_ResultScreen.dart';
import 'package:get/get.dart';

class NfcHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nfcController = Get.put(NfcController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC ile Kimlik Okuma'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.nfc, size: 100, color: Colors.blue),
                      const SizedBox(height: 20),
                      const Text(
                        'Kimlik Kartınızı NFC ile Okuyun',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Obx(() {
                        return ElevatedButton.icon(
                          icon: nfcController.isReading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Icon(Icons.nfc),
                          label: nfcController.isReading.value
                              ? const Text('Okuma Yapılıyor...')
                              : const Text('NFC Okumayı Başlat'),
                          onPressed: nfcController.isReading.value
                              ? null
                              : () async {
                                  await nfcController.startNfcReading();
                                  if (nfcController.tckn.value.isNotEmpty) {
                                    Get.to(() => NfcResultScreen());
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 60),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
