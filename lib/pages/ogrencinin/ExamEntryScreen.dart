import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExamEntryScreen extends StatefulWidget {
  final String ogrenciAdi;
  final String ogrenciNumarasi;

  const ExamEntryScreen({
    Key? key,
    required this.ogrenciAdi,
    required this.ogrenciNumarasi,
  }) : super(key: key);

  @override
  _ExamEntryScreenState createState() => _ExamEntryScreenState();
}

class _ExamEntryScreenState extends State<ExamEntryScreen> {
  final TextEditingController matematikController = TextEditingController();
  final TextEditingController turkceController = TextEditingController();
  final TextEditingController sosyalController = TextEditingController();
  final TextEditingController fenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Sınav Girişi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: matematikController,
              decoration: InputDecoration(labelText: 'Matematik Neti'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: turkceController,
              decoration: InputDecoration(labelText: 'Türkçe Neti'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: sosyalController,
              decoration: InputDecoration(labelText: 'Sosyal Bilgiler Neti'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: fenController,
              decoration: InputDecoration(labelText: 'Fen Bilimleri Neti'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveExamResults();
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExamResults() {
    final matematikNotu = int.tryParse(matematikController.text);
    final turkceNotu = int.tryParse(turkceController.text);
    final sosyalNotu = int.tryParse(sosyalController.text);
    final fenNotu = int.tryParse(fenController.text);

    if (matematikNotu != null &&
        turkceNotu != null &&
        sosyalNotu != null &&
        fenNotu != null) {
      final examData = {
        'matematik': matematikNotu,
        'turkce': turkceNotu,
        'sosyal': sosyalNotu,
        'fen': fenNotu,
      };

      FirebaseFirestore.instance
          .collection('ebeveyn')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cocuklar')
          .doc(widget.ogrenciNumarasi)
          .collection('sinavlar')
          .doc()
          .set(examData)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sınav sonuçları kaydedildi.')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm notları girin.')),
      );
    }
  }
}
