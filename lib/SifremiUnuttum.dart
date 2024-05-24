import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SifremiUnuttum extends StatefulWidget {
  const SifremiUnuttum({super.key});

  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  final TextEditingController _mailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _mailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama e-postası gönderildi')),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Şifre Sıfırlama',
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Şifre Sıfırlama E-postası Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
