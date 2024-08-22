import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_scan/Vekaletname/Vekaletname_Views/Vekaletname_RecognizerScreen.dart';
import 'package:get/get.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VekaletnameHomeScreen extends StatefulWidget {
  @override
  _VekaletnameHomeScreenState createState() => _VekaletnameHomeScreenState();
}

class _VekaletnameHomeScreenState extends State<VekaletnameHomeScreen> {
  final List<File> scannedImages = [];
  final List<String> scannedImageNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vekaletname Yükleme'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
                      Icon(Icons.insert_drive_file_outlined,
                          size: 100, color: Colors.blue),
                      const SizedBox(height: 20),
                      const Text(
                        'Vekaletname Yükleyin',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Devam etmek için lütfen belgelerinizi tarayın.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Kamerayı Aç ve Tara'),
                        onPressed: () async {
                          await _scanAndAskNext(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (scannedImages.isNotEmpty) ...[
                        Text(
                          'Taranan Sayfalar:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ReorderableListView(
                            children: [
                              for (int i = 0; i < scannedImages.length; i++)
                                ListTile(
                                  key: ValueKey(scannedImages[i].path),
                                  title: Text(scannedImageNames[i]),
                                  leading: Image.file(
                                    scannedImages[i],
                                    width: 50,
                                    height: 50,
                                  ),
                                  trailing: Icon(Icons.drag_handle),
                                ),
                            ],
                            onReorder: (int oldIndex, int newIndex) {
                              if (newIndex > oldIndex) newIndex -= 1;
                              setState(() {
                                final File image =
                                    scannedImages.removeAt(oldIndex);
                                final String name =
                                    scannedImageNames.removeAt(oldIndex);
                                scannedImages.insert(newIndex, image);
                                scannedImageNames.insert(newIndex, name);
                              });
                            },
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Sıralamayı Onayla ve Devam Et'),
                          onPressed: () {
                            Get.to(() => RecognizerScreen(scannedImages));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 60),
                          ),
                        ),
                      ],
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

  Future<void> _scanAndAskNext(BuildContext context) async {
    String? imagePath = await scanDocumentWithCamera();
    if (imagePath != null && imagePath.isNotEmpty) {
      File scannedImage = File(imagePath);
      setState(() {
        scannedImages.add(scannedImage);
        scannedImageNames.add('Sayfa ${scannedImages.length}');
      });

      // Kullanıcıya başka bir fotoğraf yüklemek isteyip istemediğini soralım
      bool addAnother = await _showAddMoreDialog(context);

      if (addAnother) {
        await _scanAndAskNext(context);
      }
    } else {
      Get.snackbar('Hata', 'Fotoğraf taranamadı.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<bool> _showAddMoreDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Başka bir fotoğraf yüklemek ister misiniz?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Hayır'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Evet'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<String?> scanDocumentWithCamera() async {
    String imagePath = join(
      (await getApplicationSupportDirectory()).path,
      "${DateTime.now().millisecondsSinceEpoch}.jpeg",
    );

    try {
      bool success =
          await EdgeDetection.detectEdge(imagePath, canUseGallery: false);
      if (success) {
        return imagePath;
      }
    } catch (e) {
      print("Tarama işlemi sırasında bir hata oluştu: $e");
    }
    return null;
  }
}
