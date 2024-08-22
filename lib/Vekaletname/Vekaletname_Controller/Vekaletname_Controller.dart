import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class VekaletnameController extends GetxController {
  RxList<File> vekaletImages = <File>[].obs;
  RxList<String> recognizedTexts = <String>[].obs;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> processVekaletnameImages(List<File> imageFiles) async {
    vekaletImages.clear();
    recognizedTexts.clear();
    for (var imageFile in imageFiles) {
      vekaletImages.add(imageFile);

      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedTextResult =
          await textRecognizer.processImage(inputImage);

      recognizedTexts.add(recognizedTextResult.text);
      print("Extracted Text: ${recognizedTextResult.text}");
    }
  }

  Future<void> saveVekaletnameData() async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      for (int i = 0; i < vekaletImages.length; i++) {
        String imagePath =
            '${appDir.path}/vekaletname_${DateTime.now().millisecondsSinceEpoch}_$i.png';
        String textPath = '${appDir.path}/recognized_vekaletname_text_$i.txt';

        // Fotoğrafı kaydet
        await File(vekaletImages[i].path).copy(imagePath);

        // Tanımlanan metinleri kaydet
        File textFile = File(textPath);
        await textFile.writeAsString(recognizedTexts[i]);
      }

      Get.snackbar('Başarılı', 'Vekaletname verileri başarıyla kaydedildi.',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Hata', 'Veriler kaydedilirken bir hata oluştu.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
