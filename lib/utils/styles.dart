import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String labelText, IconButton? iconButton) {
  return InputDecoration(
    suffixIcon: iconButton ?? iconButton,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal.shade200),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent.shade100),
    ),
    focusColor: Colors.redAccent.shade100,
    floatingLabelStyle: TextStyle(color: Colors.teal.shade200),
    labelText: labelText,
    errorStyle: TextStyle(color: Colors.redAccent.shade100),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent.shade100),
    ),
  );
}
