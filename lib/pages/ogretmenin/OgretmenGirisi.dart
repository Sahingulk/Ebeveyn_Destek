import 'package:ebeveyn_destek/SifremiUnuttum.dart';
import 'package:ebeveyn_destek/pages/ogretmenin/OgretmenAnaSayfa.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OgretmenGirisi extends StatefulWidget {
  const OgretmenGirisi({Key? key}) : super(key: key);

  @override
  _OgretmenGirisiState createState() => _OgretmenGirisiState();
}

class _OgretmenGirisiState extends State<OgretmenGirisi> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _mailController.text,
        password: _sifreController.text,
      );

      // Giriş başarılı, Ana Sayfaya yönlendir.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OgretmenAnaSayfa()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarılı')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: ${e.message}')),
      );
    }
  }

  void _navigateToSifremiUnuttum() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SifremiUnuttum()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğretmen Girişi'),
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
                'Öğretmen Girişi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _mailController,
                decoration: const InputDecoration(
                  hintText: 'Mail Adresi',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Giriş Yap'),
              ),
              TextButton(
                onPressed: _navigateToSifremiUnuttum,
                child: const Text('Şifremi Unuttum'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
