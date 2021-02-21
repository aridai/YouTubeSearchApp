import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_search_app/dependency.dart';
import 'package:youtube_search_app/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Dependency.setup();
  runApp(MyApp());
}
