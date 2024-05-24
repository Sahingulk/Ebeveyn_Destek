import 'package:ebeveyn_destek/pages/ebeveynin/EbeveynAnaEkran.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OgrenciEkle extends StatelessWidget {
  const OgrenciEkle({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController adController = TextEditingController();
    TextEditingController numaraController = TextEditingController();
    TextEditingController sifreController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: adController,
              decoration: const InputDecoration(
                hintText: 'Öğrenci Adı',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: numaraController,
              decoration: const InputDecoration(
                hintText: 'Öğrenci Numarası',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: sifreController,
              decoration: const InputDecoration(
                hintText: 'Verilecek Şifre',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addStudent(context, adController.text, numaraController.text, sifreController.text);
              },
              child: const Text('Öğrenci Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  void _addStudent(BuildContext context, String ad, String numara, String sifre) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Şifrenin öğretmen koleksiyonunda olup olmadığını kontrol et
        final QuerySnapshot result = await _firestore
            .collection('ogretmen')
            .where('verilcek_sifre', isEqualTo: sifre)
            .get();
        
        if (result.docs.isNotEmpty) {
          // Şifre geçerli ise öğrenci ekle
          await _firestore.collection('ebeveyn').doc(currentUser.uid).collection('Cocuklar').add({
            'ogrenciAdi': ad,
            'ogrenciNumarasi': numara,
            'verilenSifre': sifre, // Öğrenciye verilen şifreyi kaydet
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ParentHomeScreen()),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Öğrenci başarıyla eklendi')),
          );
        } else {
          // Şifre geçersizse hata mesajı göster
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Geçersiz şifre')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı bulunamadı')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }
}
