import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningResourcesScreen extends StatelessWidget {
  final String ogrenciAdi;
  final String ogrenciNumarasi;

  const LearningResourcesScreen({
    Key? key,
    required this.ogrenciAdi,
    required this.ogrenciNumarasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eğitim Kaynakları',
          style: TextStyle(
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Eğitim Kaynakları',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
               
                
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    const url = 'https://ogmmateryal.eba.gov.tr/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 2, 51, 91),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black45,
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.video_library, color: Colors.white),
                  label: const Text('Eğitim Videoları', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () 
                    async {
                    const url = 'https://ogmmateryal.eba.gov.tr/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  
                    // Eğitim Kitapları butonuna basıldığında yapılacak işlemler
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 2, 51, 91),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black45,
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.book, color: Colors.white),
                  label: const Text('Eğitim Kitapları', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
