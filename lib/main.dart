import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';

// Import the screens your app uses (adjust paths if different)
import 'package:ecommerce_app/screens/auth_wrapper.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/signup_screen.dart';
import 'package:ecommerce_app/screens/home_screen.dart';

Future<void> main() async {
  // Ensure bindings and preserve native splash while we init
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Try to initialize Firebase but never block removing the splash forever.
  // Any initialization error is logged and the app will still start.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Optional: small debug listener — safe because we imported firebase_auth
    FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint('MAIN authStateChanges -> user: ${user?.uid ?? "null"}');
    });
  } catch (e, st) {
    debugPrint('Firebase initialization error: $e\n$st');
    // Continue to run the app even if Firebase init failed.
  }

  // Provide app-level providers and run the app
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );

  // Remove native splash now that runApp has been called
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCommerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}