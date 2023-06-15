// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hint;
  TextEditingController cntrl;
  MyTextField({super.key, required this.hint, required this.cntrl});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: cntrl,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
