import 'package:ebeveyn_destek/pages/ogrencinin/DersProgramlama.dart';
import 'package:ebeveyn_destek/pages/ogrencinin/EgitimKaynaklari.dart';
import 'package:ebeveyn_destek/pages/ogrencinin/SinavTakibiAnaliz.dart';
import 'package:flutter/material.dart';

class Ogrenci extends StatelessWidget {
  final String ogrenciAdi;
  final String ogrenciNumarasi;

  const Ogrenci({
    required this.ogrenciAdi,
    required this.ogrenciNumarasi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$ogrenciAdi Detayları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Program Oluştur butonuna basıldığında yapılacak işlemler
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonPlanningScreen(
                      ogrenciAdi: ogrenciAdi,
                      ogrenciNumarasi: ogrenciNumarasi,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Program Oluştur',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Eğitim Kaynakları butonuna basıldığında yapılacak işlemler
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearningResourcesScreen(
                      ogrenciAdi: ogrenciAdi,
                      ogrenciNumarasi: ogrenciNumarasi,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Eğitim Kaynakları',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Sınav Takibi Analizi butonuna basıldığında yapılacak işlemler
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamAnalysisScreen(
                      ogrenciAdi: ogrenciAdi,
                      ogrenciNumarasi: ogrenciNumarasi,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                shadowColor: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Sınav Takibi Analizi',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
