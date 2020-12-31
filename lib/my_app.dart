import 'package:flutter/material.dart';
import 'package:youtube_search_app/search/search_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'YouTubeSearchApp',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SearchPage(),
      );
}
