import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningResourcesScreen extends StatelessWidget {
  final String ogrenciAdi;
  final String ogrenciNumarasi;

  const LearningResourcesScreen({
    Key? key,
    required this.ogrenciAdi,
    required this.ogrenciNumarasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eğitim Kaynakları'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Eğitim Kaynakları',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                const url = 'https://ogmmateryal.eba.gov.tr/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('Eğitim Videoları', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Eğitim Kitapları butonuna basıldığında yapılacak işlemler
              },
              child: const Text('Eğitim Kitapları', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
