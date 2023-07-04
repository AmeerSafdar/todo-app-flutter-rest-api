// ignore_for_file: file_names, unused_local_variable, must_be_immutable, sort_child_properties_last
import 'package:flutter/material.dart';

import '../../helper/constant/screen_percentage.dart';

class SizeBoxWidget extends StatelessWidget {
  SizeBoxWidget({super.key, this.heights, this.childs, this.widths});
  double? heights;
  double? widths;
  Widget? childs;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: widths,
        child: childs,
        height: heights ?? size.height * ScreenPercentage.SCREEN_SIZE_1);
  }
}
