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
        title: Text('Ders Programlama - ${widget.ogrenciAdi}',
         style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                    
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ders Programları',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
                      return const Center(child: Text('Henüz ders programı yok', style: TextStyle(color: Colors.white)));
                    }
                    final plans = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index].data() as Map<String, dynamic>;
                        final planId = plans[index].id;
                        return Card(
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(plan['konu'] ?? 'Konu Yok', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Bitiş Tarihi: ${plan['bitisTarihi'].toDate()}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteLessonPlan(planId),
                            ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: konuController,
                decoration: InputDecoration(
                  labelText: 'Konu',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bitisController,
                decoration: InputDecoration(
                  labelText: 'Bitiş Tarihi (YYYY-MM-DD)',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _createLessonPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 51, 91),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Oluştur', style: TextStyle(color: Colors.white,fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
