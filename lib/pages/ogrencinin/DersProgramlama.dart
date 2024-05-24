// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LessonPlanningScreen extends StatefulWidget {
  final String ogrenciAdi;
  final String ogrenciNumarasi;

  const LessonPlanningScreen({
    Key? key,
    required this.ogrenciAdi,
    required this.ogrenciNumarasi,
  }) : super(key: key);

  @override
  _LessonPlanningScreenState createState() => _LessonPlanningScreenState();
}

class _LessonPlanningScreenState extends State<LessonPlanningScreen> {
  final TextEditingController konuController = TextEditingController();
  final TextEditingController bitisController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createLessonPlan() async {
    try {
      await _firestore
          .collection('ebeveyn')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cocuklar')
          .doc(widget.ogrenciNumarasi)
          .collection('DersProgramlari')
          .add({
        'konu': konuController.text,
        'olusturmaTarihi': Timestamp.now(),
        'bitisTarihi': Timestamp.fromDate(DateTime.parse(bitisController.text)),
      });
      konuController.clear();
      bitisController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ders programı başarıyla oluşturuldu')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  Future<void> _deleteLessonPlan(String planId) async {
    try {
      await _firestore
          .collection('ebeveyn')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cocuklar')
          .doc(widget.ogrenciNumarasi)
          .collection('DersProgramlari')
          .doc(planId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ders programı başarıyla silindi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ders Programlama - ${widget.ogrenciAdi}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ders Programları',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('ebeveyn')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Cocuklar')
                    .doc(widget.ogrenciNumarasi)
                    .collection('DersProgramlari')
                    .orderBy('olusturmaTarihi', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Henüz ders programı yok'));
                  }
                  final plans = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index].data() as Map<String, dynamic>;
                      final planId = plans[index].id;
                      return ListTile(
                        title: Text(plan['konu'] ?? 'Konu Yok'),
                        subtitle: Text('Bitiş Tarihi: ${plan['bitisTarihi'].toDate()}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteLessonPlan(planId),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Yeni Ders Programı Oluştur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: konuController,
              decoration: const InputDecoration(labelText: 'Konu'),
            ),
            TextField(
              controller: bitisController,
              decoration: const InputDecoration(labelText: 'Bitiş Tarihi (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createLessonPlan,
              child: const Text('Oluştur', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
