import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      child: MaterialButton(
        height: 40,


        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color(0xffECCA9C),
        textColor: Colors.black,
        onPressed: onPressed,
        child: Text(
          title,
          style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:20),
        ),
      ),
    );
  }
}