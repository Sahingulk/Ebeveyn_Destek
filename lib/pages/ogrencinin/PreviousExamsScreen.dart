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
        title: const Text('Önceki Sınavlar'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              child: Text('Önceki sınav bulunamadı.'),
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
                      Text('Matematik: ${examData['matematik']}'),
                      Text('Türkçe: ${examData['turkce']}'),
                      Text('Sosyal Bilgiler: ${examData['sosyal']}'),
                      Text('Fen Bilimleri: ${examData['fen']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
