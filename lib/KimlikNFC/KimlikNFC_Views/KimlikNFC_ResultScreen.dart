import 'package:flutter/material.dart';
import 'package:flutter_scan/KimlikNFC/KimlikNFC_Controller/KimlikNFC_Controller.dart';
import 'package:flutter_scan/KimlikNFC/KimlikNFC_Views/KimlikNFC_HomePage.dart';
import 'package:get/get.dart';

class NfcResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nfcController = Get.find<NfcController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kimlik Bilgileri'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TCKN: ${nfcController.tckn.value}', style: _textStyle()),
            const SizedBox(height: 10),
            Text('Ad: ${nfcController.ad.value}', style: _textStyle()),
            const SizedBox(height: 10),
            Text('Soyad: ${nfcController.soyad.value}', style: _textStyle()),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => NfcHomeScreen()),
                child: const Text('Ana Sayfaya Dön'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  }
}
