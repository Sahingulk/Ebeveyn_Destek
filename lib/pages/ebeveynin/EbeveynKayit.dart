import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebeveyn_destek/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KayitOl extends StatefulWidget {
  const KayitOl({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KayitOlState createState() => _KayitOlState();
}

class _KayitOlState extends State<KayitOl> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  // final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  // final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _sifreTekrarController = TextEditingController();

  Future<void> _register() async {
    if (_sifreController.text == _sifreTekrarController.text) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _mailController.text,
          password: _sifreController.text,
        );

        await _firestore.collection('ebeveyn').doc(userCredential.user!.uid).set({
          'ad': _adController.text,
          'soyad': _soyadController.text,
          // 'kullaniciAdi': _kullaniciAdiController.text,
          'mail': _mailController.text,
          // 'telefon': _telefonController.text,
          // 'Cocuklar':{},
        });
         Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı')),
        );
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
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
                'Ebeveyn Kayıt',
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
              // const SizedBox(height: 10),
              // TextFormField(
              //   controller: _kullaniciAdiController,
              //   decoration: const InputDecoration(
              //     hintText: 'Kullanıcı Adı',
              //   ),
              // ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mailController,
                decoration: const InputDecoration(
                  hintText: 'Mail Adresi',
                ),
              ),
              const SizedBox(height: 10),
              // TextFormField(
              //   controller: _telefonController,
              //   decoration: const InputDecoration(
              //     hintText: 'Telefon Numarası',
              //   ),
              // ),
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
