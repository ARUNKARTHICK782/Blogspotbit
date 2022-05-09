import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class requestform extends StatefulWidget {
  const requestform({Key? key}) : super(key: key);

  @override
  State<requestform> createState() => _requestformState();
}

class _requestformState extends State<requestform> {
  var namecontr=TextEditingController();
  var noOfpeoplecontr=TextEditingController();
  var addresscontr=TextEditingController();
  var phnocontr=TextEditingController();
  var emerphnocontr=TextEditingController();
  var citycontr=TextEditingController();
  String dropdownValue="Home";
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
            Row(
          children: [
            Text("Place Of Requirement"),
            SizedBox(width: 20,),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              underline: Container(
                height: 2,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Home', 'Orphanage', 'School']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
            TextField(
              onChanged: (s){
                setState(() {

                });
              },
              cursorColor:const Color(0xfff50f0f),
              controller: noOfpeoplecontr,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                ),
                labelText: 'No Of People',
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
              cursorColor:const Color(0xfff50f0f),
              controller: phnocontr,
              keyboardType: TextInputType.number,

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
              cursorColor:const Color(0xfff50f0f),
              controller: emerphnocontr,
              keyboardType: TextInputType.number,

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
            ElevatedButton(onPressed: (){}, child: Text("Request"))
          ],
        ),
      ),
    );
  }
}
