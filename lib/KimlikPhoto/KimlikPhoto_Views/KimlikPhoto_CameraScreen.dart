import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
import 'package:get/get.dart';
import 'package:flutter_scan/KimlikPhoto/KimlikPhoto_Views/KimlikPhoto_DetailPage.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isFrontCaptured = false;
  bool isScanningMRZ = false;
  String frontImagePath = '';
  String backImagePath = '';
  String mrzResult = '';
  MRZController? mrzController;
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  CameraDescription? selectedCamera;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    selectedCamera = cameras!.first;

    cameraController = CameraController(
      selectedCamera!,
      ResolutionPreset.high,
    );

    await cameraController?.initialize();

    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isScanningMRZ ? buildMRZScanner() : buildCameraPreviewScreen(context),
          if (!isScanningMRZ)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (cameraController != null &&
                        cameraController!.value.isInitialized) {
                      XFile file = await cameraController!.takePicture();
                      onCapture(file.path);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 50,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isFrontCaptured ? 'Arka Yüzü Çek' : 'Ön Yüzü Çek',
                  ),
                ),
              ),
            ),
          // Çerçeve
          if (!isScanningMRZ)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCameraPreviewScreen(BuildContext context) {
    if (!isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return CameraPreview(cameraController!);
  }

  Widget buildMRZScanner() {
    return MRZScanner(
      withOverlay: true,
      onControllerCreated: (MRZController controller) {
        this.mrzController = controller;
        mrzController!.startPreview();

        mrzController!.onParsed = (result) async {
          setState(() {
            mrzResult = '''
Döküman Tipi: ${result.documentType}
Ülke: ${result.countryCode}
Soyadı: ${result.surnames}
İsim: ${result.givenNames}
Seri No: ${result.documentNumber}
Doğum Tarihi: ${result.birthDate}
Uyruk: ${result.nationalityCountryCode}
Son Geçerlilik: ${result.expiryDate}
Kimlik No: ${result.personalNumber}
''';
          });

          mrzController!.stopPreview();
          _showResults();
        };
      },
    );
  }

  void onCapture(String imagePath) {
    if (!isFrontCaptured) {
      setState(() {
        frontImagePath = imagePath;
        isFrontCaptured = true;
      });
      Get.snackbar('Başarılı', 'Ön yüz başarıyla kaydedildi.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16.0));
    } else {
      setState(() {
        backImagePath = imagePath;
        isScanningMRZ = true;
      });
    }
  }

  void _showResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          frontImagePath: frontImagePath,
          backImagePath: backImagePath,
          mrzResult: mrzResult,
        ),
      ),
    );
  }

  @override
  void dispose() {
    mrzController?.stopPreview();
    cameraController?.dispose();
    super.dispose();
  }
}
