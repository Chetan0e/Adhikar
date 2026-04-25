import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/blocs/language/language_cubit.dart';
import 'core/constants/hive_boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint(
        'Please ensure google-services.json (Android) or GoogleService-Info.plist (iOS) is present.');
  }

  // Initialize Hive for offline storage
  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox(HiveBoxes.kUserProfileBox);
  await Hive.openBox(HiveBoxes.kSchemesBox);
  await Hive.openBox(HiveBoxes.kApplicationsBox);
  await Hive.openBox(HiveBoxes.kSyncQueueBox);
  await Hive.openBox(HiveBoxes.kSettingsBox);

  // Load saved language before rendering
  final languageCubit = LanguageCubit();
  await languageCubit.loadSavedLanguage();

  runApp(
    BlocProvider<LanguageCubit>.value(
      value: languageCubit,
      child: const AdhikarApp(),
    ),
  );
}
