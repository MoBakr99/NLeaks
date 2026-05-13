import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:n_leaks/core/data/preferences/preference_manager.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await PreferenceManager().init();
}