import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/constants/hive_boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive for offline storage
  await Hive.initFlutter();
  
  // Register Hive adapters
  // Hive.registerAdapter(UserProfileAdapter());
  // Hive.registerAdapter(SchemeAdapter());
  // Hive.registerAdapter(ApplicationAdapter());
  
  // Open Hive boxes
  await Hive.openBox(HiveBoxes.kUserProfileBox);
  await Hive.openBox(HiveBoxes.kSchemesBox);
  await Hive.openBox(HiveBoxes.kApplicationsBox);
  await Hive.openBox(HiveBoxes.kSyncQueueBox);
  await Hive.openBox(HiveBoxes.kSettingsBox);
  
  runApp(const AdhikarApp());
}
