import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebeveyn_destek/pages/ebeveynin/bildirimler.dart';
import 'package:ebeveyn_destek/pages/ebeveynin/ogrenciKayit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ebeveyn_destek/pages/ogrencinin/ogrenci.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({Key? key});

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
        title: const Text('Ebeveyn Ana Ekranı',
         style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
         ),
         backgroundColor: const Color.fromARGB(255, 2, 51, 91),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ogram oluşturma.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OgrenciEkle()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  backgroundColor: const Color.fromARGB(255, 2, 51, 91),
                ),
                child: const Text(
                  'Öğrenci Kayıt',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kayıtlı Öğrenciler',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),),
                
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cocuklar.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: ListTile(
                        title: Text(
                          cocuklar[index]['ogrenciAdi']!,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text(cocuklar[index]['ogrenciNumarasi']!),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
