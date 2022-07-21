import 'dart:async';
import 'dart:ui';
import 'package:blogspotbit/main.dart';
import 'package:blogspotbit/responsive.dart';
import 'package:blogspotbit/tempfile/tempdartfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'Components/styles.dart';
import 'apihandler.dart';
import 'block_picker.dart';
import 'colors/colors.dart';
import 'screens/desktopcontainer.dart';

var verify, reg_email, reg_department, reg_name;
var user, token, otpjson;
tempclass obj=new tempclass();
void _launchURL() async {
  const _url = "https://forms.gle/ScqKF8EqBS69LxNCA";
  if (!await launch(_url)) throw 'Could not launch $_url';
}

toast(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Color(0xfff50f0f),
      textColor: Colors.white,
      fontSize: 16.0
  );

  return "true";
}


getotp(String? email, String? subject) async {

  var b={"email":email,"type":subject};

  var res=await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/send/email/otp"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':obj.str,
    },
    body: json.encode(b),
  );

  if(res.body.toString() =='"email" must be a valid email') return res.body.toString();
  else if (res.body.toString() == "User Already registered") return res.body.toString();
  var finaldetails = json.decode(res.body);
  otpjson = finaldetails;
  return finaldetails;
}

verifyotp(String? key, int? otp, String? check) async {
  var b ={
    "verification_key": key,
    "otp":otp,
    "check": check
  };

  var res = await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/send/verify/otp"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':obj.str,
    },
    body: json.encode(b),
  );
  var finaldetails = json.decode(res.body);
  if(finaldetails['Details'].toString() == 'OTP NOT Matched') return 'OTP NOT Matched';
  verify = finaldetails;
  reg_name = verify['Check'].toString().substring(0,1).toUpperCase()+verify['Check'].toString().substring(1, verify['Check'].toString().indexOf('.'));
  reg_department = verify['Check'].toString().substring(verify['Check'].toString().indexOf('.')+1, verify['Check'].toString().indexOf('.')+3);
  reg_email = verify['Check'].toString();
  return finaldetails;
}

adduser(String? name, String? email, String? password,String colors) async {
  var prefs=await SharedPreferences.getInstance();
  var b={"name": name,"email":email,"password":password,"profile_color":colors};
  var res=await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/add"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Secret_Key':tempclass.inte.toString(),
    },
    body: json.encode(b),
  );
  token = res.headers['x-auth-token'];
  await prefs.setString("token", token);
  return res.body;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    PageController pc=PageController(initialPage: 1);
    return Scaffold(
      appBar: (Responsive.isMobile(context))?AppBar(
        backgroundColor: Color(0xfff50f0f),
        title: Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Text("BLOGSPOTBIT"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,10,8),
            child: ElevatedButton(onPressed: () => {
              _launchURL()
            },
              child: Text("Help",style:TextStyle(color: Color(0xfff50f0f))),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ),
        ],
      ):PreferredSize(preferredSize: Size(0,0), child: Container(color:Color(0xfff50f0f)),),
      body: SingleChildScrollView(
        child: Center(
          child: (Responsive.isMobile(context))?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 33.5,
              ),
              Hero(
                  tag: "image",
                  child: Container(
                    child: Image(
                        image: AssetImage("images/FrontBanner.png")),
                  )
              ),
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
          ):Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(image: AssetImage("images/FrontBanner.png")),
                desktopcontainer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var username=new TextEditingController();
  var password=new TextEditingController();
  bool contentvalidate=false;
  bool contentro=true;
  bool usernameerror=false;
  bool passworderror=false, password_visible = true,loading=false;
  int len=0;
  String temp="", token="";
  Color currentColor = Colors.amber;
  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) => setState(() => currentColors = colors);

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff50f0f),
        title: Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Text("BLOGSPOTBIT"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,10,8),
            child: ElevatedButton(onPressed: () => {
              _launchURL()
            },
              child: Text("Help",style:TextStyle(color: Color(0xfff50f0f))),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("")),
                    Expanded(
                      flex:5,
                      child: Container(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: TextField(
                                      inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 . @]'))],
                                      onChanged: (s){
                                        setState(() {
                                          temp=s;
                                        });

                                        if(s.contains("@bitsathy.ac.in")){

                                          setState(() {
                                            usernameerror=false;
                                          });
                                        }
                                        else{
                                          setState(() {
                                            usernameerror=true;
                                          });
                                        }

                                      },
                                      cursorColor:Color(0xfff50f0f),
                                      controller: username,
                                      decoration: InputDecoration(
                                        errorText: usernameerror?"Invalid Email":null,
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color:Color(0xff334f7f), width: 2)
                                        ),
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff334f7f)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Expanded(flex:3,child: Container(width: double.infinity,)),

                              ],
                            )),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text("")),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("")),
                    Expanded(
                      flex:5,
                      child: Container(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: TextField(
                                      obscureText: password_visible,
                                      onChanged: (s){
                                        setState(() {
                                          temp=s;
                                        });

                                        if(s.length<=12){
                                          setState(() {
                                            passworderror=false;
                                          });
                                        }
                                        else{
                                          setState(() {
                                            passworderror=true;
                                          });
                                        }

                                      },
                                      controller: password,
                                      cursorColor:Color(0xfff50f0f),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: (){
                                              setState(() {
                                                password_visible = !password_visible;
                                              });
                                            },
                                            icon: password_visible?Icon(Icons.remove_red_eye, color: Colors.grey,):Icon(Icons.remove_red_eye,color: Color(0xfff50f0f),)),
                                        errorText: passworderror?"InValid Password":null,
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color:Color(0xff334f7f), width: 2)                                        ),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff334f7f)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Expanded(flex:3,child: Container(width: double.infinity,)),

                              ],
                            )),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text("")),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(onPressed: () async{
                    setState(() {
                      loading=true;
                    });
                    if(username.text.isEmpty || password.text.isEmpty){
                      toast("Email and Password required");
                      setState(() {
                        loading=false;
                      });
                      return;
                    }

                    if(!usernameerror && !passworderror){
                      await gettoken(username.text.trim(), password.text.trim()).then((v) async {
                        setState(() {
                          loading=false;
                        });
                        if(v == "Invalid Email or Password"){
                            toast("Invalid Email or Password");
                        }
                        else if (v == '"email" must be a valid email'){
                          toast("Invalid Email");
                        }
                        else{
                          var prefs= await SharedPreferences.getInstance();
                          prefs.setString("token", v).then((value) {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>home()),((route) => false));
                          });
                        }
                      });

                    }
                    else{
                      if(usernameerror) return toast("Invalid Email");
                      if(passworderror) return toast("Invalid Password");
                      setState(() {
                        loading=false;
                      });
                    }
                  }, child: Text("LOGIN"),
                    style: ElevatedButton.styleFrom(primary: Color(0xfff50f0f)),
                  ),
                ),
                (loading)?CircularProgressIndicator(
                  color: tertiary(),
                ):Text(""),
                Image(image: AssetImage("images/LoginBanner.png")),


              ],),
          ),
        ),
      )
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Timer ?_timer;
  int _min = 00;
  int _sec = 30;
  bool zero = false;
  var username=new TextEditingController();
  var password=new TextEditingController();
  var otp=new TextEditingController();
  bool contentvalidate=false;
  bool contentro=true;
  bool rusernameerror=false;
  bool rpassworderror=false;
  bool rotperror=false;
  int len=0;
  bool check=false, check2 = true, check3 = true;
  bool loading=false;
  String temp="", token="";
  var decodeotp;
  Color colors=Colors.black;


  @override
  void dispose() {
    username.dispose();
    password.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_min == 0 && _sec == 0) {
          setState(() {
            timer.cancel();
            toast("Timed out try again");
            Navigator.pop(context);
          });
        } else {
          if(_sec == 0){
            setState(() {
              _min--;
              _sec= 60;
              zero = false;
            });
          }
          else{
            if(_sec < 11 && _sec > 0){
              zero = true;
            }
            else{
              zero = false;
            }
          }
          setState(() {
            _sec--;
          });
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff50f0f),
        title: Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Text("BLOGSPOTBIT"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,10,8),
            child: ElevatedButton(onPressed: () => {
              _launchURL()
            },
              child: Text("Help",style:TextStyle(color: Color(0xfff50f0f))),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("")),
                    Expanded(
                      flex:5,
                      child: Container(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: TextField(
                                      inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 . @]'))],
                                      onChanged: (s){
                                        setState(() {
                                          temp=s;
                                        });

                                        // if(s.contains("@bitsathy.ac.in")){
                                        //   setState(() {
                                        //     rusernameerror=false;
                                        //   });
                                        // }
                                        // else{
                                        //   setState(() {
                                        //    rusernameerror=true;
                                        //   });
                                        // }

                                      },
                                      controller: username,
                                      cursorColor: Color(0XFFF50F0F),
                                      decoration: InputDecoration(
                                        // errorText: rusernameerror?"Invalid Email":null,
                                        border: UnderlineInputBorder(),
                                          labelText: 'Email',
                                        focusedBorder: textfieldborder(),
                                        suffixText: "@bitsathy.ac.in",
                                        labelStyle: textfieldlabel()
                                      ),
                                    ),
                                  ),
                                ),
                                // Expanded(flex:3,child: Container(width: double.infinity,)),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text("")),
                  ],
                ),

                check?Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("")),
                    Expanded(
                      flex:5,
                      child: Column(
                        children: [
                          Container(
                            child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                        child: TextField(

                                          onChanged: (s){
                                            setState(() {
                                              temp=s;
                                            });

                                            if(s.length<7){
                                              setState(() {
                                                rotperror=false;
                                              });
                                            }
                                            else{
                                              setState(() {
                                                rotperror=true;
                                              });
                                            }

                                          },
                                          cursorColor: Color(0xfff50F0F),
                                          controller: otp,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            errorText: rotperror?"Valid Password":null,
                                            border: UnderlineInputBorder(),
                                            focusedBorder: textfieldborder(),
                                            labelText: 'OTP',
                                            labelStyle: textfieldlabel()
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Expanded(flex:3,child: Container(width: double.infinity,)),

                                  ],
                                )),
                          ),
                          zero?Text("0$_min : 0$_sec"):Text("0$_min : $_sec"),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text("")),
                  ],
                ):Text(""),

                check2?Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(onPressed: () async{
                    setState(() {
                      loading=true;
                    });
                    if(username.text.isEmpty ) {
                      toast("Email is required");
                      return;
                    }

                    if(!rusernameerror){
                      await getotp(username.text.trim()+"@bitsathy.ac.in", "VERIFICATION").then((v) => {

                        if(v =='"email" must be a valid email'){
                          toast("Invalid Email")
                        }
                        else if (v == "User Already registered"){
                          toast("You have Already Registered")
                        }
                        else{
                          setState(() {
                            loading=false;
                            check = true;
                            check2 = false;
                            startTimer();
                          })
                        }
                      });

                    }
                    else{
                      toast("Only bitsathy accounts allowed");
                      return;
                    }
                  }, child: Text("SEND OTP"),
                    style: ElevatedButton.styleFrom(primary: Color(0xfff50f0f)),
                  ),
                ):Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(onPressed: () async{
                    setState(() {
                      loading=true;
                    });
                    if(otp.text.length == 0) return;

                    if(!rotperror ){

                        await verifyotp(otpjson['Details'], int.parse(otp.text), username.text+"@bitsathy.ac.in").then((v) {

                          if(v == 'OTP NOT Matched'){
                            toast('OTP NOT Matched');
                          }
                          else if(v['Status'].toString() == 'Success'){
                            _timer?.cancel();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const OTPVerified(),));
                          }
                          else{

                          }

                        });


                    }
                    else{
                    }
                  }, child: Text("START REGISTRATION"),
                    style: ElevatedButton.styleFrom(primary: Color(0xfff50f0f)),
                  ),
                ),
                (loading)?CircularProgressIndicator(color: tertiary(),):Text(""),
                Image(image: AssetImage("images/LoginBanner.png")),
              ],),
          ),
        ),
      )
    );
  }
}

class OTPVerified extends StatefulWidget {
  const OTPVerified({Key? key}) : super(key: key);

  @override
  State<OTPVerified> createState() => _OTPVerifiedState();
}

class _OTPVerifiedState extends State<OTPVerified> {

  var username = new TextEditingController();
  var depart = new TextEditingController();
  var password = new TextEditingController();
  var mail = new TextEditingController();
  bool check_password = false, password_visible = true, back_bool=false;
  Color colors=Color(0xff0000FF);


  @override
    void dispose() {
      // _timer?.cancel();
      super.dispose();
    }

  @override
  void initState() {
    username.text = reg_name;
    if(reg_department == 'cs'){
      depart.text = "CSE";
    }
    mail.text = reg_email;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context, builder: (BuildContext context){
          return  AlertDialog(
            content: Text("Do you want to exit?",style: TextStyle(color: secondary(), fontWeight: FontWeight.bold),),
            actions: [
              TextButton(onPressed: () async{
                  back_bool=true;
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()), (route) => false);

              }, child: Text("YES",style: TextStyle(color: tertiary(), fontWeight: FontWeight.bold),)),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("NO",style: TextStyle(color: tertiary(), fontWeight: FontWeight.bold),))
            ],
          );
        });
        return back_bool;
      },
      child: Scaffold(
          //

          // PreferredSize(child: Container(
          //   height: 200.0,
          //   decoration: BoxDecoration(
          //     color: secondary(),
          //     boxShadow: [
          //       new BoxShadow(blurRadius: 10.0)
          //     ],
          //     borderRadius: BorderRadius.vertical(
          //         bottom: Radius.elliptical(
          //             MediaQuery.of(context).size.width, 120.0)),
          //   ),
          // ), preferredSize: Size.fromHeight(120.0), ),
        appBar:AppBar(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(30),
        //   ),
        // ),
        backgroundColor: Color(0xfff50f0f),
        title: Padding(

          padding: const EdgeInsets.only(left:10.0),
          child: Text("BlogSpotBIT")
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,10,8),
            child: ElevatedButton(onPressed: () => {
              _launchURL()
            },
              child: Text("Help",style:TextStyle(color: Color(0xfff50f0f))),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          )
        ],
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:35.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("")),
                    Center(
                      child: Text("REGISTRATION", style: TextStyle(color: Color(0xfff50f0f), fontSize: 20),),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text("")),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("")),
                  Expanded(
                    flex:5,
                    child: Container(
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: CircleAvatar(
                                  child: Text(username.text.substring(0)[0],style: TextStyle(fontSize: 50,color: Colors.white),),
                                  radius: 40,
                                  backgroundColor: colors,
                                ),
                              ),
                              // Expanded(flex:3,child: Container(width: double.infinity,)),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text("")),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("")),
                  Expanded(
                    flex:5,
                    child: Container(
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: TextButton(
                                    onPressed: (){
                                      showDialog(context: context, builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: MaterialColorPicker(
                                              colors: [
                                                Colors.red,
                                                Colors.yellow,
                                                Colors.blue,
                                                Colors.pink,
                                                Colors.green
                                              ],

                                              onColorChange: (Color color) {
                                                setState(() {
                                                  colors = color;
                                                });
                                                // Handle color changes
                                              },

                                              selectedColor: colors
                                          ),
                                        );
                                      });
                                    }
                                    , child: Text("Choose...",style: TextStyle(color: Color(0xff334f7f)),)),
                              ),
                              // Expanded(flex:3,child: Container(width: double.infinity,)),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text("")),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("")),
                  Expanded(
                    flex:5,
                    child: Container(
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(

                                  child: TextField(

                                    readOnly:true,
                                    onChanged: (s){
                                      setState(() {

                                      });

                                      // if(s.contains("@bitsathy.ac.in")){
                                      //   setState(() {
                                      //     usernameerror=false;
                                      //   });
                                      // }
                                      // else{
                                      //   setState(() {
                                      //     usernameerror=true;
                                      //   });
                                      // }

                                    },
                                    cursorColor: Color(0xfff50f0f),
                                    controller: username,
                                    decoration: InputDecoration(
                                      // errorText: usernameerror?"Invalid Email":null,
                                      border: UnderlineInputBorder(),
                                      labelText: 'Name',
                                        focusedBorder: textfieldborder(),

                                        labelStyle: textfieldlabel()
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(flex:3,child: Container(width: double.infinity,)),

                            ],
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text("")),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("")),
                  Expanded(
                    flex:5,
                    child: Container(
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(
                                  child: TextField(
                                    readOnly:true,
                                    onChanged: (s){
                                      setState(() {

                                      });
                                      // if(s.contains("@bitsathy.ac.in")){
                                      //   setState(() {
                                      //     usernameerror=false;
                                      //   });
                                      // }
                                      // else{
                                      //   setState(() {
                                      //     usernameerror=true;
                                      //   });
                                      // }

                                    },
                                    cursorColor: Color(0xfff50f0f),
                                    controller: depart,
                                    decoration: InputDecoration(
                                      // errorText: usernameerror?"Invalid Email":null,
                                      border: UnderlineInputBorder(),
                                      labelText: 'Department',
                                        focusedBorder: textfieldborder(),

                                        labelStyle: textfieldlabel()
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(flex:3,child: Container(width: double.infinity,)),

                            ],
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text("")),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("")),
                  Expanded(
                    flex:5,
                    child: Container(
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(
                                  child: TextField(
                                    readOnly:true,
                                    onChanged: (s){
                                      setState(() {

                                      });

                                      // if(s.contains("@bitsathy.ac.in")){
                                      //   setState(() {
                                      //     usernameerror=false;
                                      //   });
                                      // }
                                      // else{
                                      //   setState(() {
                                      //     usernameerror=true;
                                      //   });
                                      // }

                                    },
                                    cursorColor: Color(0xfff50f0f),
                                    controller: mail,
                                    decoration: InputDecoration(
                                      // errorText: usernameerror?"Invalid Email":null,
                                      border: UnderlineInputBorder(),
                                      labelText: 'Email',
                                        focusedBorder: textfieldborder(),

                                        labelStyle: textfieldlabel()
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(flex:3,child: Container(width: double.infinity,)),

                            ],
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text("")),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("")),
                  Expanded(
                    flex:5,
                    child: Container(
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(
                                  child: TextField(

                                    obscureText: password_visible,
                                    onChanged: (s){
                                      setState(() {

                                      });
                                      if(8<=s.length && s.length<=12){
                                        setState(() {
                                          check_password=false;
                                        });
                                      }
                                      else{
                                        setState(() {
                                          check_password=true;
                                        });
                                      }


                                    },
                                    cursorColor: Color(0xfff50f0f),
                                    controller: password,
                                    decoration: InputDecoration(
                                      errorText: check_password?"Invalid Password":null,
                                      border: UnderlineInputBorder(),
                                      labelText: 'Password',
                                        focusedBorder: textfieldborder(),

                                        labelStyle: textfieldlabel(),
                                      suffixIcon: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              password_visible = !password_visible;
                                            });
                                          },
                                          icon: password_visible?Icon(Icons.remove_red_eye, color: Colors.grey,):Icon(Icons.remove_red_eye,color: Color(0xfff50f0f),))
                                    ),

                                  ),
                                ),
                              ),
                              // Expanded(flex:3,child: Container(width: double.infinity,)),

                            ],
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text("")),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(onPressed: () async{
                  if(password.text.length == 0 ) return;

                  if(!check_password){
                    await adduser(username.text, mail.text, password.text,colors.toString().substring(6,16)).then((user){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>home()),(route)=>false);
                    });
                  }
                  else{

                  }
                }, child: Text("REGISTER"),
                  style: ElevatedButton.styleFrom(primary: Color(0xfff50f0f)),

                ),
              )
            ],
          ),
        )
      ),
    );
  }
}



