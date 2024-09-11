import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final IconData? icon;
  final VoidCallback? onPressed;

  const CustomTextForm({
    Key? key,
    required this.hinttext,
    required this.mycontroller,
    required this.validator,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontFamily:ArabicFont.arefRuqaa,// Example: Fallback font for non-Android platforms
          fontWeight: FontWeight.normal, // You might need to adjust font weight as well
        ),

        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor: Color(0xFFFFE7C7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color:Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.black),
        ),
        suffixIcon: icon != null
            ? IconButton(
          icon: Icon(icon,color: Colors.black),

          onPressed: onPressed,
        )
            : null,
      ),
    );
  }
}
