// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OgretmenAnaSayfa extends StatefulWidget {
  const OgretmenAnaSayfa({super.key});

  @override
  _OgretmenAnaSayfaState createState() => _OgretmenAnaSayfaState();
}

class _OgretmenAnaSayfaState extends State<OgretmenAnaSayfa> {
  String ogretmenAdiSoyadi = '';
  String verilcekSifre = '';
  List<Map<String, dynamic>> ogrenciler = [];

  @override
  void initState() {
    super.initState();
    _fetchOgretmenBilgileri();
  }

  void _fetchOgretmenBilgileri() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('ogretmen')
          .doc(currentUser.uid)
          .get();
      // ignore: unnecessary_cast
      final ogretmenData = docSnapshot.data() as Map<String, dynamic>?;
      if (ogretmenData != null) {
        setState(() {
          ogretmenAdiSoyadi = '${ogretmenData['ad']} ${ogretmenData['soyad']}';
          verilcekSifre = ogretmenData['verilcek_sifre'];
        });
        _fetchStudents();
      }
    }
  }

  void _fetchStudents() async {
    List<Map<String, dynamic>> fetchedStudents = [];
    final QuerySnapshot ebeveynSnapshot = await FirebaseFirestore.instance.collection('ebeveyn').get();
    for (var ebeveynDoc in ebeveynSnapshot.docs) {
      final QuerySnapshot cocuklarSnapshot = await FirebaseFirestore.instance
          .collection('ebeveyn')
          .doc(ebeveynDoc.id)
          .collection('Cocuklar')
          .where('verilenSifre', isEqualTo: verilcekSifre)
          .get();
      fetchedStudents.addAll(cocuklarSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'ogrenciAdi': data['ogrenciAdi'],
          'ogrenciNumarasi': data['ogrenciNumarasi'],
          'ebeveynId': ebeveynDoc.id,
        };
      }).toList());
    }
    setState(() {
      ogrenciler = fetchedStudents;
    });
  }

  void _sendMessage(String ebeveynId, String ogrenciAdi, String ogrenciNumarasi) {
    TextEditingController mesajController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mesaj Gönder'),
        content: TextFormField(
          controller: mesajController,
          decoration: const InputDecoration(hintText: 'Mesajınızı girin'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              if (mesajController.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('ebeveyn')
                    .doc(ebeveynId)
                    .collection('bildirimler')
                    .add({
                  'mesaj': mesajController.text,
                  'ogrenciAdi': ogrenciAdi,
                  'ogrenciNumarasi': ogrenciNumarasi,
                  'tarih': Timestamp.now(),
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mesaj gönderildi')),
                );
              }
            },
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoşgeldiniz, $ogretmenAdiSoyadi'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: ogrenciler.length,
          itemBuilder: (context, index) {
            final ogrenci = ogrenciler[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(
                  ogrenci['ogrenciAdi'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Numara: ${ogrenci['ogrenciNumarasi']}'),
                onTap: () {
                  _sendMessage(ogrenci['ebeveynId'], ogrenci['ogrenciAdi'], ogrenci['ogrenciNumarasi']);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
