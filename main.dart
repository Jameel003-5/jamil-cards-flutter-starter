import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Screens/previwe_screen.dart';
import 'binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCd7k5uD3oVGQTV-3HzzOwn_2zGZSNaFE4",
        //authDomain: "nfcqr-a1d80.firebaseapp.com",
        projectId: "jamilnfc-bc4bb",
        //storageBucket: "nfcqr-a1d80.appspot.com",
        messagingSenderId: "1009343189634",
        appId: "1:1009343189634:web:281c62c39e9bc88ed25a9b",
    ),
       // measurementId: "G-1CHMZK5G27")

  );
  runApp(GetMaterialApp(
      getPages: [
        GetPage(
          name: '/:userId',
          page: () => PreviewProfileScreen(),
        ),
      ],
      initialRoute: '/:userId',
      initialBinding: Binding(),
      debugShowCheckedModeBanner: false,
  ),
  );

}





