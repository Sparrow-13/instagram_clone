import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:instagram_clone/context/global_context.dart';
import 'package:instagram_clone/screens/splash_screen.dart';
import 'package:path_provider/path_provider.dart'; // Required for getting application directory
import 'package:provider/provider.dart';

import 'entity/user/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);
  FirebaseAuth.instance.setLanguageCode('en');

  Hive.registerAdapter(UserAdapter());
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalContext(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}
