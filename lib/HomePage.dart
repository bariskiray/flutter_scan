import 'package:flutter_scan/KimlikNFC/KimlikNFC_Views/KimlikNFC_HomePage.dart';
import 'package:flutter_scan/KimlikPhoto/KimlikPhoto_Views/KimlikPhoto_HomePage.dart';
import 'package:flutter_scan/Vekaletname/Vekaletname_Views/Vekaletname_HomeScreen.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HomeCard(
              icon: Icons.upload_file,
              title: 'Vekaletname Yükleme',
              description: 'Vekaletname belgenizi buradan yükleyin.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VekaletnameHomeScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            HomeCard(
              icon: Icons.photo_camera,
              title: 'Kimlik Fotoğrafı Taratma',
              description: 'Kimlik fotoğrafınızı buradan taratın.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KimlikphotoHomepage()),
                );
              },
            ),
            SizedBox(height: 20),
            HomeCard(
              icon: Icons.nfc,
              title: 'NFC ile Kimlik Tarama',
              description: 'Kimlik kartınızı NFC ile tarayın.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NfcHomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  HomeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 50, color: Colors.blue),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
