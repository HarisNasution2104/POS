import 'package:flutter/material.dart';
const Color whiteColor = Colors.white;
const Color mainColor = Color(0xFFE76F51);


PreferredSizeWidget customAppBar(String title, {List<Widget>? actions,bool centerTitle = false, // default false
}) {
  return AppBar(
    foregroundColor: whiteColor,
    backgroundColor: mainColor,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: centerTitle,
    elevation: 0,
    actions: actions,
  );
}
