// ignore_for_file: file_names, unused_local_variable
import 'package:flutter/material.dart';

import '../../helper/constant/screen_percentage.dart';

class SizeBoxWidget extends StatelessWidget {
  const SizeBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(height: size.height * ScreenPercentage.SCREEN_SIZE_1);
  }
}
