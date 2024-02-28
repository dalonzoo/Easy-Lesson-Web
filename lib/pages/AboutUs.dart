
import 'package:flutter/material.dart';


import 'package:Easy_Lesson_web/utils/Values.dart';
import 'package:Easy_Lesson_web/widgets/AboutUs_view.dart';



class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Lesson',
      home: AboutUs_view(),
    );
  }
}