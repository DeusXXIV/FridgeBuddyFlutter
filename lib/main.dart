import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';
import 'services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final householdId = await LocalStorage.loadHouseholdId();

  runApp(
    ProviderScope(
      child: FridgeBuddyApp(initialHouseholdId: householdId),
    ),
  );
}

class FridgeBuddyApp extends StatelessWidget {
  final String? initialHouseholdId;

  const FridgeBuddyApp({super.key, required this.initialHouseholdId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "FridgeBuddy",
      routerConfig: createAppRouter(initialHouseholdId),
    );
  }
}

