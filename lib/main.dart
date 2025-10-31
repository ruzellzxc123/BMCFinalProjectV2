// ...existing code...
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Import screens for route registration
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/signup_screen.dart';
import 'package:ecommerce_app/screens/auth_wrapper.dart';
// ...existing code...
import 'package:firebase_auth/firebase_auth.dart';
// ...existing code...

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Debug: listen to auth changes at startup
  FirebaseAuth.instance.authStateChanges().listen((user) {
    debugPrint('MAIN authStateChanges -> user: ${user?.uid ?? "null"}');
  });

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eCommerce App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}