import 'package:ebeveyn_destek/pages/ogretmenin/OgretmenKayit.dart';
import 'package:flutter/material.dart';
import 'package:ebeveyn_destek/pages/ebeveynin/EbeveynKayit.dart';
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ekranı'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child:const Text("EBEVEYN DESTEK",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),



              ),

              const SizedBox( height:20),
              ElevatedButton(
                onPressed: () {
                  // Ebeveyn kaydı butonuna basıldığında yapılacak işlemler
                  // Örneğin, ebeveyn kayıt sayfasına yönlendirme işlemi burada gerçekleştirilebilir.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KayitOl() ),
                  );
                },
                child: const Text('Ebeveyn Kaydı', style: TextStyle(fontSize: 15)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Öğretmen kaydı butonuna basıldığında yapılacak işlemler
                  // Örneğin, öğretmen kayıt sayfasına yönlendirme işlemi burada gerçekleştirilebilir.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OgretmenKayit() ),
                  );
                },
                child: const Text('Öğretmen Kaydı', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}