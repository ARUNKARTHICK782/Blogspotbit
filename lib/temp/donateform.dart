import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class donateform extends StatefulWidget {
  const donateform({Key? key}) : super(key: key);

  @override
  State<donateform> createState() => _donateformState();
}

class _donateformState extends State<donateform> {
  var namecontr=TextEditingController();
  var quantcontr=TextEditingController();
  var addresscontr=TextEditingController();
  var phnocontr=TextEditingController();
  var emerphnocontr=TextEditingController();
  var validitycont=TextEditingController();
  var citycontr=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 50,right: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (s){
                setState(() {

                });
              },
              cursorColor:const Color(0xfff50f0f),
              controller: namecontr,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                ),
                labelText: 'Name',
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff334f7f)
                ),
              ),
            ),
            TextField(
              onChanged: (s){
                setState(() {

                });
              },
              cursorColor:const Color(0xfff50f0f),
              controller: quantcontr,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                ),
                labelText: 'Quantity',
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff334f7f)
                ),
              ),
            ),
            TextField(
              onChanged: (s){
                setState(() {

                });
              },
              cursorColor:const Color(0xfff50f0f),
              controller: addresscontr,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                ),
                labelText: 'Address',
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff334f7f)
                ),
              ),
            ),
            TextField(
              onChanged: (s){
                setState(() {

                });
              },
              keyboardType: TextInputType.number,

              cursorColor:const Color(0xfff50f0f),
              controller: phnocontr,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                ),
                labelText: 'Phno',
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff334f7f)
                ),
              ),
            ),
            TextField(
              onChanged: (s){
                setState(() {

                });
              },
              keyboardType: TextInputType.number,
              cursorColor:const Color(0xfff50f0f),
              controller:emerphnocontr,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                ),
                labelText: 'Emergency Phno',
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff334f7f)
                ),
              ),
            ),
            TextField(
              onChanged: (s){
                setState(() {

                });
              },
              cursorColor:const Color(0xfff50f0f),
              controller: citycontr,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                ),
                labelText: 'City',
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff334f7f)
                ),
              ),
            ),
            ElevatedButton(onPressed: (){}, child: Text("Donate"))
          ],
        ),
      ),
    );
  }
}
