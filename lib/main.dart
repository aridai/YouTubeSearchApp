import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_search_app/dependency.dart';
import 'package:youtube_search_app/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Dependency.setup();
  runApp(MyApp());
}
