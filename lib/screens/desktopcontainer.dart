import 'package:blogspotbit/firstpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class desktopcontainer extends StatefulWidget {
  const desktopcontainer({Key? key}) : super(key: key);

  @override
  State<desktopcontainer> createState() => _desktopcontainerState();
}

class _desktopcontainerState extends State<desktopcontainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 450,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 75.0),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                });

                //showblogs();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0,top: 8.0, bottom: 8.0),
                    child: Icon(Icons.login, color: Color(0xfff50f0f),size: 35,),
                  ),
                  Text("LOGIN",style: TextStyle(color: Color(0xfff50f0f)),),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:47.5),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0,top: 8.0, bottom: 8.0),
                    child: Icon(Icons.app_registration, color: Color(0xfff50f0f),size: 35,),
                  ),
                  Text("REGISTER",style: TextStyle(color: Color(0xfff50f0f)),),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
