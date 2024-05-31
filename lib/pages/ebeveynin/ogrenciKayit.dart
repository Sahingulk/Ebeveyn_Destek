import 'package:ebeveyn_destek/pages/ebeveynin/EbeveynAnaEkran.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OgrenciEkle extends StatelessWidget {
  const OgrenciEkle({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController adController = TextEditingController();
    TextEditingController numaraController = TextEditingController();
    TextEditingController sifreController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Ekle',
         style: TextStyle(color: Colors.white)
        
        ),
         centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 51, 91),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),

      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ogram oluşturma.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: adController,
                decoration: InputDecoration(
                  hintText: 'Öğrenci Adı',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: numaraController,
                decoration: InputDecoration(
                  hintText: 'Öğrenci Numarası',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: sifreController,
                decoration: InputDecoration(
                  hintText: 'Verilecek Şifre',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addStudent(context, adController.text, numaraController.text, sifreController.text);
                },
                child: const Text('Öğrenci Ekle',
                 style: TextStyle(color: Colors.white)
                ),
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 2, 51, 91),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addStudent(BuildContext context, String ad, String numara, String sifre) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final QuerySnapshot result = await _firestore
            .collection('ogretmen')
            .where('verilcek_sifre', isEqualTo: sifre)
            .get();
        
        if (result.docs.isNotEmpty) {
          await _firestore.collection('ebeveyn').doc(currentUser.uid).collection('Cocuklar').add({
            'ogrenciAdi': ad,
            'ogrenciNumarasi': numara,
            'verilenSifre': sifre,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ParentHomeScreen()),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Öğrenci başarıyla eklendi')),
          );
        } else {
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
