import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_scan/HomePage.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class DetailPage extends StatelessWidget {
  final String frontImagePath;
  final String backImagePath;
  final String mrzResult;

  DetailPage({
    required this.frontImagePath,
    required this.backImagePath,
    required this.mrzResult,
  });

  @override
  Widget build(BuildContext context) {
    // Ön ve arka yüz fotoğraflarını kırp
    final croppedFrontImage = cropImage(frontImagePath);
    final croppedBackImage = cropImage(backImagePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kimlik Bilgileri ve MRZ Sonuçları'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kimlik Ön Yüzü',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Image.memory(
              croppedFrontImage,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Kimlik Arka Yüzü',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Image.memory(
              croppedBackImage,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'MRZ Tarama Sonuçları',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                mrzResult,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Veriler kaydedildi mesajı ve ana sayfaya yönlendirme
                  Get.snackbar(
                    'Başarılı',
                    'Veriler başarıyla kaydedildi.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(16.0),
                  );

                  // Ana sayfaya yönlendirme
                  Future.delayed(const Duration(seconds: 2), () {
                    Get.offAll(() => HomePage());
                  });
                },
                child: const Text('Gönder'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Görüntüyü kırpan fonksiyon
  Uint8List cropImage(String imagePath) {
    final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());
    if (originalImage == null) return Uint8List(0);

    // Kırpma alanı
    int cropX = (originalImage.width * 0.1).round();
    int cropY = (originalImage.height * 0.4).round();
    int cropWidth = (originalImage.width * 0.8).round();
    int cropHeight = (originalImage.height * 0.4).round();

    final croppedImage = img.copyCrop(
      originalImage,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );

    return Uint8List.fromList(img.encodeJpg(croppedImage));
  }
}
