import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcController extends GetxController {
  RxString tckn = ''.obs;
  RxString ad = ''.obs;
  RxString soyad = ''.obs;
  RxBool isReading = false.obs;

  Future<void> startNfcReading() async {
    // NFC'nin mevcut olup olmadığını kontrol edin
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      Get.snackbar(
        'NFC Hatası',
        'Cihazda NFC özelliği mevcut değil veya kapalı. Lütfen cihaz ayarlarınızı kontrol edin.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // NFC oturumunu başlatma
    try {
      isReading.value = true;
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null) {
          Get.snackbar(
              'Hata', 'Geçersiz NFC tagı. Lütfen geçerli bir kart okutun.',
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        // NFC verilerini okuma ve ayırma
        for (var record in ndef.cachedMessage!.records) {
          String payload = String.fromCharCodes(record.payload);
          tckn.value = _parseData(payload, "TCKN");
          ad.value = _parseData(payload, "Ad");
          soyad.value = _parseData(payload, "Soyad");
        }

        // NFC oturumunu durdurma
        NfcManager.instance.stopSession();
        Get.snackbar(
          'Başarılı',
          'Kimlik bilgileri başarıyla okundu.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
    } catch (e) {
      Get.snackbar(
        'Hata',
        'NFC okuma sırasında bir hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isReading.value = false;
    }
  }

  String _parseData(String payload, String key) {
    if (payload.contains(key)) {
      return payload.split(":")[1].trim();
    }
    return '';
  }
}
