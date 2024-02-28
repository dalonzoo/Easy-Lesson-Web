import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Easy_Lesson_web/utils/theme_selector.dart';

class CustomTab extends StatelessWidget {
  CustomTab({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Text(this.title,
            style: TextStyle(fontSize: 18
                ,fontFamily: 'HindSiliguri'
            ,color: Colors.black
            )));
  }
}
