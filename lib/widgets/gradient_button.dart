import 'package:flutter/material.dart';
import 'package:Easy_Lesson_web/utils/colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({Key? key,required this.color}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradient1,
           Colors.green,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(395,55),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
        onPressed: (){},
        child: const Text('Trova orario',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          )),



        )
      ,


    );
  }
}
