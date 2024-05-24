import 'package:ebeveyn_destek/pages/ogrencinin/ExamEntryScreen.dart';
import 'package:ebeveyn_destek/pages/ogrencinin/PreviousExamsScreen.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class ExamAnalysisScreen extends StatelessWidget {
  final String ogrenciAdi;
  final String ogrenciNumarasi;

  const ExamAnalysisScreen({
    Key? key,
    required this.ogrenciAdi,
    required this.ogrenciNumarasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav Takibi Analizi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sınav Takibi Analizi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Sınav Girişi butonuna basıldığında yapılacak işlemler
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamEntryScreen(
                      ogrenciAdi: ogrenciAdi,
                      ogrenciNumarasi: ogrenciNumarasi,
                    ),
                  ),
                );
              },
              child: const Text('Sınav Girişi', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Önceki Sınavlar butonuna basıldığında yapılacak işlemler
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviousExamsScreen(
                      ogrenciAdi: ogrenciAdi,
                      ogrenciNumarasi: ogrenciNumarasi,
                    ),
                  ),
                );
              },
              child: const Text('Önceki Sınavlar', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
