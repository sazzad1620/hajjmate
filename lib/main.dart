import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hajjmate/firebase_options.dart';
import 'package:hajjmate/hajjmate_app.dart';
import 'package:hajjmate/src/config/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(const HajjMateApp());
}
