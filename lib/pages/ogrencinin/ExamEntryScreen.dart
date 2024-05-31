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
        title: const Text('Yeni Sınav Girişi',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 51, 91),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ogram oluşturma.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Lütfen sınav netlerinizi girin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTextField(matematikController, 'Matematik Neti'),
                const SizedBox(height: 10),
                _buildTextField(turkceController, 'Türkçe Neti'),
                const SizedBox(height: 10),
                _buildTextField(sosyalController, 'Sosyal Bilgiler Neti'),
                const SizedBox(height: 10),
                _buildTextField(fenController, 'Fen Bilimleri Neti'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveExamResults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 2, 51, 91),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black45,
                    elevation: 8,
                  ),
                  child: const Text('Kaydet', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
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
        'olusturmaTarihi': Timestamp.now(),
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
        matematikController.clear();
        turkceController.clear();
        sosyalController.clear();
        fenController.clear();
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
