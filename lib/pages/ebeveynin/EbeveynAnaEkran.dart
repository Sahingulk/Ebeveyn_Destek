import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebeveyn_destek/pages/ebeveynin/bildirimler.dart';
import 'package:ebeveyn_destek/pages/ebeveynin/ogrenciKayit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ebeveyn_destek/pages/ogrencinin/ogrenci.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  List<Map<String, String>> cocuklar = [];

  @override
  void initState() {
    super.initState();
    _fetchChildren();
  }

  void _fetchChildren() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ebeveyn')
          .doc(currentUser.uid)
          .collection('Cocuklar')
          .get();
      final List<Map<String, String>> fetchedChildren = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data); // Veri kontrolü için geçici print ifadesi
        return {
          'ogrenciAdi': data['ogrenciAdi']?.toString() ?? '',
          'ogrenciNumarasi': data['ogrenciNumarasi']?.toString() ?? '',
        };
      }).toList();

      setState(() {
        cocuklar = fetchedChildren;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebeveyn Ana Ekranı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EbeveynBildirim()), // Bildirimler sayfasına yönlendirme
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OgrenciEkle()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.grey,
                  ),
                  child: Ink.image(
                    image: const AssetImage('assets/images/ana_sayfa21.jpg'),
                    fit: BoxFit.cover,
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Öğrenci Kayıt',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kayıtlı Öğrenciler',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cocuklar.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: ListTile(
                      title: Text(cocuklar[index]['ogrenciAdi']!),
                      subtitle: Text(cocuklar[index]['ogrenciNumarasi']!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ogrenci(
                              ogrenciAdi: cocuklar[index]['ogrenciAdi']!,
                              ogrenciNumarasi: cocuklar[index]['ogrenciNumarasi']!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
