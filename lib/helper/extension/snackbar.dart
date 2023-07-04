import 'package:flutter/material.dart';

showSnackbar(BuildContext cntxt, String content) {
  ScaffoldMessenger.of(cntxt).showSnackBar(SnackBar(
      content: Text(
    content,
    style: const TextStyle(color: Colors.white),
  )));
}

extension snackBarExtension on BuildContext {
  void snaxkbar(String content) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(
      content,
      style: const TextStyle(color: Colors.white),
    )));
  }
}
