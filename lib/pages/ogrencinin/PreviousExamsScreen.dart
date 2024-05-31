import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreviousExamsScreen extends StatelessWidget {
  final String ogrenciAdi;
  final String ogrenciNumarasi;

  const PreviousExamsScreen({
    Key? key,
    required this.ogrenciAdi,
    required this.ogrenciNumarasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Önceki Sınavlar',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 51, 91),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ogram oluşturma.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ebeveyn')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Cocuklar')
              .doc(ogrenciNumarasi)
              .collection('sinavlar')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return const Center(
                child: Text('Önceki sınav bulunamadı.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final examData = documents[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Matematik: ${examData['matematik']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text('Türkçe: ${examData['turkce']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text('Sosyal Bilgiler: ${examData['sosyal']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text('Fen Bilimleri: ${examData['fen']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
