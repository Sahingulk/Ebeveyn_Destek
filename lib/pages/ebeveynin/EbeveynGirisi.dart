import 'package:ebeveyn_destek/SifremiUnuttum.dart';
import 'package:ebeveyn_destek/pages/ebeveynin/EbeveynAnaEkran.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EbeveynGirisi extends StatefulWidget {
  const EbeveynGirisi({super.key});

  @override
  _GirisYapState createState() => _GirisYapState();
}

class _GirisYapState extends State<EbeveynGirisi> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _mailController.text,
        password: _sifreController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarılı')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ParentHomeScreen()),
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
        title: const Text('Giriş Yap'),
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
                'Ebeveyn Giriş',
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
              const SizedBox(height: 10),
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
