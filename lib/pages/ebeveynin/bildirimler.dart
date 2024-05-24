import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EbeveynBildirim extends StatelessWidget {
  const EbeveynBildirim({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
      ),
      body: currentUser == null
          ? const Center(child: Text('Kullanıcı bulunamadı'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ebeveyn')
                  .doc(currentUser.uid)
                  .collection('bildirimler')
                  .orderBy('tarih', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data =
                        documents[index].data() as Map<String, dynamic>;
                    final Timestamp timestamp = data['tarih'];
                    final DateTime dateTime = timestamp.toDate();
                    final String formattedDate =
                        DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: ListTile(
                        title: Text(data['ogrenciAdi']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Numara: ${data['ogrenciNumarasi']}'),
                            Text(formattedDate),
                            const SizedBox(height: 5),
                            Text(data['mesaj']),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('ebeveyn')
                                .doc(currentUser.uid)
                                .collection('bildirimler')
                                .doc(documents[index].id)
                                .delete();
                          },
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
