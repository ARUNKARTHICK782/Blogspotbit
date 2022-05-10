import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildChip(String label, Color color) {
  int? _value = 1;
  return ChoiceChip(
    labelPadding: EdgeInsets.all(2.0),
    avatar: CircleAvatar(
      backgroundColor: Colors.white70,
      child: Text(label[0].toUpperCase()),
    ),
    label: Text(
      label,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: color,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: EdgeInsets.all(8.0), selected: true ,

  );
}
