import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

UnderlineInputBorder textfieldborder(){
  return UnderlineInputBorder(
      borderSide: BorderSide(color:Color(0xff334f7f), width: 2)
  );
}

TextStyle textfieldlabel(){
  return TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xff334f7f)
  );
}

Column forshimmer(){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 155*2,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:Colors.grey,
        ),
      ),
      SizedBox(
        height: 13,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:Colors.grey,
        ),
        height: 20,
        width: 120*2,
      ),
      SizedBox(
        height: 13,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:Colors.grey,
        ),
        height: 20,
        width: 170*2,
      ),
      SizedBox(
        height: 13,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:Colors.grey,
        ),
        height: 20,
        width: 80*2,
      ),
    ],
  );
}
