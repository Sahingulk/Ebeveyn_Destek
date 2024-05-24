import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebeveyn_destek/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OgretmenKayit extends StatefulWidget {
  const OgretmenKayit({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OgretmenKayitState createState() => _OgretmenKayitState();
}

class _OgretmenKayitState extends State<OgretmenKayit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _ogretmenIdController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _sifreTekrarController = TextEditingController();

  Future<void> _register() async {
    if (_sifreController.text == _sifreTekrarController.text) {
      try {
        // Benzersizlik kontrolü
        final QuerySnapshot snapshot = await _firestore
            .collection('ogretmen')
            .where('verilcek_sifre', isEqualTo: _ogretmenIdController.text)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verilecek şifre zaten kullanılıyor')),
          );
          return;
        }

        // Kullanıcı oluşturma işlemi
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _mailController.text,
          password: _sifreController.text,
        );

        // Firestore kaydı oluşturma işlemi
        await _firestore.collection('ogretmen').doc(userCredential.user!.uid).set({
          'ad': _adController.text,
          'soyad': _soyadController.text,
          'mail': _mailController.text,
          'verilcek_sifre': _ogretmenIdController.text,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt başarısız: ${e.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifreler uyuşmuyor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ogretmen Kayıt',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _adController,
                decoration: const InputDecoration(
                  hintText: 'Ad',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _soyadController,
                decoration: const InputDecoration(
                  hintText: 'Soyad',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mailController,
                decoration: const InputDecoration(
                  hintText: 'Mail Adresi',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ogretmenIdController,
                decoration: const InputDecoration(
                  hintText: 'Verilcek Şifreniz',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _sifreController,
                decoration: const InputDecoration(
                  hintText: 'Şifre',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _sifreTekrarController,
                decoration: const InputDecoration(
                  hintText: 'Şifre Tekrarı',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
