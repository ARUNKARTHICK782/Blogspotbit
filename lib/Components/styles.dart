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
