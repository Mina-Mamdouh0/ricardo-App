import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricardo_app/bloc/ricardo_cubit.dart';
import 'package:ricardo_app/firebase_options.dart';
import 'package:ricardo_app/screen/auth/login/loginscreen.dart';
import 'package:ricardo_app/screen/home_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( BlocProvider(
      create: (_)=>RicardoCubit()..getAllProducts(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RicardoApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FirebaseAuth.instance.currentUser==null?LoginScreen():const HomeScreen(),
    );
  }
}

