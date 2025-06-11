import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  String path;
   LogoImage({super.key,required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path
     ,
      height: 180,
    );
  }
}
