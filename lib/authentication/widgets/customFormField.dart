import 'package:flutter/material.dart';


class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key, required this.hintText, required this.height, required this.validationRegEx, this.obscureText =false, required this.onSaved, });

  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool  obscureText;
  final void Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value) {
          if (value != null && validationRegEx.hasMatch(value)) {
            return null;
          }
          return 'Enter a valid ${hintText.toLowerCase()}';
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red
            ),
            borderRadius: BorderRadius.circular(15)
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}