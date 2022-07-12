import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:blogspotbit/colors/colors.dart';
import 'package:blogspotbit/screens/splashscreen.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:shimmer/shimmer.dart';
import 'package:blogspotbit/blogmodel.dart';
import 'package:blogspotbit/main.dart';
import 'package:blogspotbit/share.dart';
import 'package:blogspotbit/usermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'Components/chipbuilder.dart';
import 'Components/styles.dart';
import 'bala.dart';
import 'apihandler.dart';
import 'googleauth.dart';
import 'screens/detailedblog.dart';
// bool auth=false;
String token="";
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  bool alreadylogged=false;
  // final prefs=await SharedPreferences.getInstance();
  // alreadylogged =(await  prefs.getString("token")?.isEmpty)!;
  // if(alreadylogged){
  //   await gettoken(FirebaseAuth.instance.currentUser?.email);
  // }
  // else{
  //   print("token is not empty");
  // }

  // FirebaseAuth.instance
  //     .authStateChanges()
  //     .listen((User? user) {
  //   if (user == null) {
  //     auth=false;
  //     print('User is currently signed out!');
  //   } else {
  //     auth=true;
  //     print('User is signed in!');
  //   }
  // });
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      './blogdetail':(context)=>blogdetail(new blogmodel.empty(),0),
      './myapp':(context)=>MyApp(),
      './myblogs':(context)=>myblogs(),
    },
    theme: ThemeData(
      fontFamily: 'Merriweather',
      scaffoldBackgroundColor:  Color(0xfffaeeeb),
    ),
    home:splashscreen(), //(auth)?home():  (alreadylogged)?home():
  ));
}

enum oldShare {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:home(),

    );
  }

}

class addblog extends StatefulWidget {
  const addblog({Key? key}) : super(key: key);

  @override
  _addblogState createState() => _addblogState();
}

class _addblogState extends State<addblog> {
  var blogtitlecont=new TextEditingController();
  var blogcontentcont=new TextEditingController();
  bool contentvalidate=false;
  bool contentro=true;
  String titleerrortext="";
  String contenterrortext="";
  bool titleError=false;
  int len=0;
  String temp="";
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xfff50f0f),),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
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
                                  onChanged: (s){
                                    setState(() {
                                      temp=s;
                                    });
                                      print(s.length);
                                      if(s.length>=60){
                                        setState(() {
                                          titleError=true;
                                          titleerrortext="More than 60";
                                        });
                                      }
                                      else if(s.length<5){
                                        setState(() {
                                          titleError=true;
                                          titleerrortext="Must be greater than 5 ";
                                        });
                                      }
                                      else{
                                        setState(() {
                                          titleError=false;
                                        });
                                      }

                                  },
                                  cursorColor: Color(0xfff50f0f),
                                  controller: blogtitlecont,
                                  decoration: InputDecoration(
                                    focusColor: Color(0xfff50f0f),
                                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                      errorText: titleError?titleerrortext:null,
                                      border: UnderlineInputBorder(),
                                    focusedBorder: textfieldborder(),

                                    labelStyle: textfieldlabel(),
                                      labelText: 'Title',
                                  ),
                                ),
                              ),
                            ),
                            // Expanded(flex:3,child: Container(width: double.infinity,)),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 32.5,
                                child: CircularProgressIndicator(
                                  color: (temp.length>60)?Colors.red:tertiary(),
                                  value:(temp.length/60 *100)/100,
                                ),
                              ),
                            )
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
                        child: TextField(
                          controller: blogcontentcont,
                          onChanged: (s){
                            len=s.length;
                            if(len>1500){
                              setState(() {
                                contentvalidate=true;
                                contenterrortext="Content should not be more than 1500 characters";
                              });
                            }
                            else if(len<5){
                              setState(() {
                                contentvalidate=true;
                                contenterrortext="Less than 5 characters";
                              });
                            }
                            else{
                              setState(() {
                                contentvalidate=false;
                              });
                            }

                          },
                          maxLines: 20,
                          cursorColor: Color(0xfff50f0f),
                          decoration: InputDecoration(
                              errorText: contentvalidate?contenterrortext:null,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color:Color(0xff334f7f), width: 2)
                              ),
                              hintStyle: textfieldlabel(),
                              hintText: 'Content'
                          ),
                        )),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Text("")),
              ],

            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xfff50f0f)),
                onPressed: () async{
                  setState(() {
                    loading=true;
                  });
                  if(blogtitlecont.text.isEmpty){
                    toast("Title requried");
                    return ;
                  }
                  if(blogcontentcont.text.isEmpty)
                    {
                      toast("Content required");
                      return;
                    }

                  if(blogtitlecont.text.length >=60 || blogtitlecont.text.length <5){
                    if(blogtitlecont.text.length >=60){
                      toast("Title should be less than 60 characters");
                      return;
                    }
                    else{
                      toast("Title should be greater than 5 characters");
                      return;
                    }
                  }
                if(blogcontentcont.text.length > 1500 || blogcontentcont.text.length<5){
                  if(blogcontentcont.text.length > 1500)
                    {
                      toast("Content is more than 1500 characters");
                      return;
                    }
                  else
                    {
                      toast("Content is less than 5 characters");
                      return;
                    }
                }
                else{
                  var prefs=await SharedPreferences.getInstance();
                  String? id=await prefs.getString("id");
                  await addblogtodb(blogtitlecont.text,blogcontentcont.text,id!).then((value) {
                    setState(() {
                      loading=false;
                    });
                    Navigator.pop(context);
                  });
                }

            }, child: Text("PUBLISH POST")),
            (loading)?CircularProgressIndicator(
              color: tertiary(),
            ):Text("")
          ],),
        ),
      )
    );
  }
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  ScreenshotController scrncont=ScreenshotController();
  bool temp=false;
  bool like=false;
  bool tempload=true;
  List<blogmodel> blogs=[];
  List<int> mylikeslist=[];
  List<int> mybookmarkslist=[];
  List<int> myreportedblogs=[];
  bool _loading=true;
  bool templike=false;
  bool isButtondisabled=false;
  bool isBookmarkdisabled=false;
  Map<String,int> reportmap=new Map();
  bool ak=false;
  blogfunc() async{
    var response=await showblogs();
    if(response.toString() == "No Blogs Found"){
      print("NO BLOGS FOUND");
    }
    else{
      print("DATA HAVING");
      blogs=response;
    }

    setState(() {

    });
  }


updateblog() async {
  var meres=await mefunc();
  mylikeslist=await mylikes();
    mybookmarkslist=await mybookmarks();
    myreportedblogs=meres['reported'].cast<int>();
    print("my reported blogs"+myreportedblogs.toString());
    print("type of mblist");
    print(meres);
    print(mybookmarkslist.runtimeType);


    setState(() {
        _loading=false;
    });
    // for (var i in mylikeslist){
    //   for(blogmodel blog in blogs){
    //     if(blog.blogid == i){
    //
    //     }
    //   }
    // }
  }
  int? _value = 1;
  List<String> reportreason=[];
  bool reportc1=false,reportc2 =false,reportc3 =false;
  int abusive=0,spam=0,irrelevant=0;
  @override
  void initState() {
    _loading=tempload;
    blogfunc();
    updateblog();
    mefunc();
    isButtondisabled=true;
    isBookmarkdisabled=true;
    reportmap.addAll({"Abusive":0,"Irrelevant":0,"Spam":0});
  }
  var _imgfile;
  var scrcont=new ScrollController();
  @override
  Widget build(BuildContext context) {
    PageController pc=PageController(initialPage: 1);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.view_headline,color: Colors.white,),onPressed: (){
            Navigator.push(context,PageTransition(
              type: PageTransitionType.leftToRight,
              child: profile(),
            ),).then((value){
              setState(() {
                tempload=false;
                initState();
              });
            });
          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("BLOGSPOT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
              Text("BIT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                ),)
            ],),
          backgroundColor: Color(0xfff50f0f),
        ),
        body:(_loading)?Center(child: SizedBox(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.white,
                                  highlightColor: Colors.grey,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex:6 ,
                                        child: Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(

                                                height: 30,
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
                                                height: 30,
                                                width: 140,
                                              ),
                                            ],
                                          )
                                        ),
                                        Expanded(flex:1,child: IconButton(icon:Icon(Icons.flag_outlined,color: Colors.grey,),onPressed: (){},))
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Expanded(
                                  flex:8,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: Colors.grey,
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        forshimmer(),
                                        SizedBox(
                                          height:30,
                                        ),
                                        forshimmer(),

                                      ],
                                    ),
                                  ),
                                ),
                                //Spacer(),
                                Shimmer.fromColors(
                                  baseColor: Colors.white,
                                  highlightColor: Colors.grey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(flex:1,child: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Text(" ",
                                                style: TextStyle(color: Colors.white,fontSize: 22.5),
                                              ),
                                              // backgroundImage: NetworkImage(blogs.elementAt(index).authorurl),
                                            )),
                                            Expanded(
                                              flex:3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(" ",overflow: TextOverflow.ellipsis,),
                                                  SizedBox(height: 5,),
                                                  Text(
                                                    "Published On: " ,
                                                    style: TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(onPressed: () async{
                                              scrncont.capture().then((image) async {
                                                await onButtonTap(oldShare.whatsapp,image!);
                                                //Capture Done
                                                setState(() {
                                                  _imgfile = image;
                                                });
                                              }).catchError((onError) {
                                                print(onError);
                                              });

                                            }, icon: Icon(Icons.share)),
                                            Column(
                                              children: [
                                               IconButton(icon:Icon(CupertinoIcons.heart,),onPressed: () async {
                                                  setState(() {
                                                    templike=!templike;
                                                  });
                                                                                              },),
                                                Text(" ",style: TextStyle(fontSize: 10),)
                                              ],
                                            ),
                                            IconButton(icon:Icon(Icons.bookmark_outline_rounded),onPressed: () async{

                                            },),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),): Screenshot(
            controller: scrncont,
            child: GestureDetector(
              child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: blogs.length,
                  itemBuilder: (BuildContext context,int index){
                    return Column(
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                color: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex:6 ,
                                              child: Text(blogs.elementAt(index).title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(fontSize: 27.5,fontWeight: FontWeight.w500,fontFamily: 'Oswald'),
                                              ),
                                            ),
                                            Expanded(flex:1,child: IconButton(icon:Icon(Icons.flag_outlined),onPressed: (){
                                              showDialog(context: context, builder: (BuildContext context){
                                                return StatefulBuilder(
                                                  builder: (context,setState) {
                                                    return AlertDialog(
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text("Do you want to report this blog?",style: TextStyle(color: secondary(), fontWeight: FontWeight.bold),),
                                                          Wrap(
                                                            children: [
                                                              ChoiceChip(
                                                                label: Text("Abusive"),
                                                                disabledColor: Colors.grey,
                                                                selectedColor: Colors.red,
                                                                onSelected: (bool selected) {
                                                                  setState(() {
                                                                    reportc1=selected;
                                                                    if(selected){
                                                                      abusive=1;
                                                                    }
                                                                    else{
                                                                      abusive=0;
                                                                    }
                                                                  });
                                                                }, selected: reportc1,
                                                              ),
                                                              ChoiceChip(
                                                                label: Text("Irrelevant"),
                                                                disabledColor: Colors.grey,
                                                                selectedColor: Colors.red,
                                                                onSelected: (bool selected) {
                                                                  setState(() {
                                                                    reportc2=selected;
                                                                    if(selected) {
                                                                      irrelevant=1;
                                                                    }
                                                                    else{
                                                                      irrelevant=0;
                                                                    }

                                                                  });
                                                                }, selected: reportc2,
                                                              ),
                                                              ChoiceChip(
                                                                label: Text("Spam/Suspicious"),
                                                                disabledColor: Colors.grey,
                                                                selectedColor: Colors.red,
                                                                onSelected: (bool selected) {
                                                                  setState(() {
                                                                    reportc3=selected;
                                                                    if(selected){
                                                                      spam=1;
                                                                    }
                                                                    else{
                                                                      spam=0;
                                                                    }
                                                                  });
                                                                },
                                                                selected: reportc3,
                                                                selectedShadowColor: Colors.black,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(onPressed: () async{
                                                          // var df= json.encode(reportmap);
                                                          // debugPrint("Sdfdfsfs"+df.runtimeType.toString());
                                                          // String aa=reportreason.toString();
                                                          // print(aa);
                                                          // print(reportmap.toString());
                                                          await report(blogs.elementAt(index).blogid,abusive,irrelevant,spam).then((v){
                                                            tempload=false;
                                                            initState();
                                                            Navigator.of(context).pop();
                                                          });
                                                        }, child: Text("YES",style: TextStyle(color: tertiary(), fontWeight: FontWeight.bold),)),
                                                        TextButton(onPressed: (){
                                                          Navigator.of(context).pop();
                                                        }, child: Text("NO",style: TextStyle(color: tertiary(), fontWeight: FontWeight.bold),))
                                                      ],
                                                    );
                                                  }
                                                );
                                              });
                                            },))
                                          ],
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Expanded(
                                          flex:8,
                                          child: ListView(
                                            physics: NeverScrollableScrollPhysics(),
                                            children: [
                                              Text(blogs.elementAt(index).content,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 15,
                                                style: TextStyle(fontSize: 17.5,fontFamily: 'Oswald-Extra'),
                                              ),
                                              (blogs.elementAt(index).content.length>900)?TextButton(
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>detailedblog(blogs.elementAt(index))));
                                                },
                                                child: Text("Read More", style: TextStyle(color: secondary()),),
                                              ):Text(""),
                                            ],
                                          ),
                                        ),
                                        //Spacer(),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Expanded(flex:1,child: CircleAvatar(
                                                    backgroundColor: Color(int.parse(blogs.elementAt(index).authorurl)),
                                                    child: Text(blogs.elementAt(index).authorname[0],
                                                      style: TextStyle(color: Colors.white,fontSize: 22.5),
                                                    ),
                                                    // backgroundImage: NetworkImage(blogs.elementAt(index).authorurl),
                                                  )),
                                                  Expanded(
                                                    flex:3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(blogs.elementAt(index).authorname,overflow: TextOverflow.ellipsis,),
                                                        SizedBox(height: 5,),
                                                        Text(
                                                          "Published On: " +
                                                              blogs
                                                                  .elementAt(index)
                                                                  .pubdate
                                                                  .substring(0, 10),
                                                          style: TextStyle(fontSize: 10),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  IconButton(onPressed: () async{
                                                    int id=blogs.elementAt(index).blogid;

                                                    //await share(blogs.elementAt(index).blogid);
                                                    Share.share('https://blog-spot-bit-2022.herokuapp.com/api/blogs/blog/$id');
                                                    // scrncont.capture().then((image) async {
                                                    //   await onButtonTap(Share.whatsapp,image!);
                                                    //   //Capture Done
                                                    //   setState(() {
                                                    //     _imgfile = image;
                                                    //   });
                                                    // }).catchError((onError) {
                                                    //   print(onError);
                                                    // });

                                                  }, icon: Icon(Icons.share)),
                                                  Column(
                                                    children: [
                                                      (mylikeslist.contains(blogs.elementAt(index).blogid))?IconButton(icon:Icon(CupertinoIcons.heart_fill,color: Color(0xfff50f0f),),onPressed: () async {
                                                        if(isButtondisabled){
                                                          setState(() {
                                                            isButtondisabled=false;
                                                          });
                                                          await removefromMylikes(blogs.elementAt(index).blogid).then((v){
                                                            setState(() {
                                                              tempload=false;
                                                              initState();
                                                            });
                                                          });
                                                        }
                                                        else{
                                                          null;
                                                        }
                                                        // addlike(blogs.elementAt(index).blogid);
                                                        // addtomylikes(FirebaseAuth.instance.currentUser?.email, blogs.elementAt(index).blogid);
                                                        // setState(() {
                                                        //   initState();
                                                        // });
                                                      },):IconButton(icon:Icon(CupertinoIcons.heart,),onPressed: () async {
                                                        // await addlike(blogs.elementAt(index).blogid);
                                                        if(isButtondisabled){
                                                          setState(() {
                                                            isButtondisabled=false;
                                                          });
                                                          await addtomylikes(blogs.elementAt(index).blogid).then((v){
                                                            setState(() {

                                                              tempload=false;
                                                              initState();
                                                            });
                                                          });
                                                        }
                                                        else{
                                                          null;
                                                        }


                                                      },),
                                                      Text(blogs.elementAt(index).likes.toString(),style: TextStyle(fontSize: 10),)
                                                    ],
                                                  ),
                                                  (mybookmarkslist.contains(blogs.elementAt(index).blogid))?IconButton(icon:Icon(Icons.bookmark),color: tertiary(),onPressed: () async{
                                                    if(isBookmarkdisabled){
                                                      setState(() {
                                                        isBookmarkdisabled=false;
                                                      });
                                                      await removefromMybookmarks(blogs.elementAt(index).blogid).then((v){
                                                        setState(() {
                                                          tempload=false;
                                                          initState();
                                                        });
                                                      });
                                                    }
                                                    else{
                                                      null;
                                                    }


                                                  },):IconButton(icon:Icon(Icons.bookmark_outline_rounded),onPressed: () async{

                                                    if(isBookmarkdisabled){
                                                      setState(() {
                                                        isBookmarkdisabled=false;
                                                      });
                                                      await addtomybookmarks(blogs.elementAt(index).blogid).then((v){
                                                        setState(() {
                                                          tempload=false;
                                                          initState();
                                                        });
                                                      });
                                                    }
                                                    else{
                                                      null;
                                                    }

                                                  },),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    );
                  }),
              onPanUpdate: (details) {

                // Swiping in left direction.
                if (details.delta.dx > 0) {
                  Navigator.push(context,PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: profile(),
                  ),).then((value) {
                    setState(() {
                      tempload=false;
                      initState();
                    });
                  });
                }
              },
            ),
          ),
          bottomNavigationBar:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 65,
                width: 65,
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>addblog())).then((value)
                    {
                      print("after add blog");
                      tempload=true;
                      initState();
                    });
                    // Obtain shared preferences.
                  },
                  backgroundColor: Color(0xfff50f0f),
                    child: Icon(Icons.add),),
                ),
              )
            ],) ,
          // bottomNavigationBar: DescribedFeatureOverlay(
          //   featureId: 'feature1',
          //   targetColor: Colors.white,
          //   textColor: Colors.black,
          //   backgroundColor: Colors.red.shade100,
          //   contentLocation: ContentLocation.trivial,
          //   title: Text(
          //     'This is Button',
          //     style: TextStyle(fontSize: 20.0),
          //   ),
          //   pulseDuration: Duration(seconds: 1),
          //   enablePulsingAnimation: true,
          //   overflowMode: OverflowMode.extendBackground,
          //   openDuration: Duration(seconds: 1),
          //   description: Text('This is Button you can\n add more details heres'),
          //   tapTarget: Icon(Icons.navigation),
          //
          //   child: BottomNavigationBar(items: [
          //     BottomNavigationBarItem(label: "home", icon: Icon(Icons.home)),
          //     BottomNavigationBarItem(
          //         label: 'Notification',
          //         icon: Icon(Icons.notifications_active)),
          //   ]),
          // ),
        ),
    );
  }
}

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  String? disname;
  String? profilecolor;
  userfetchfunc() async{
    var prefs=await SharedPreferences.getInstance();
    setState((){
      disname= prefs.getString("name");
      profilecolor= prefs.getString("profile_color");
    });

    // print(int.parse(profilecolor.toString()));
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff50f0f),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Container(width: double.infinity,),
            CircleAvatar(
              radius: 50,
              child: Text(disname.toString().substring(0,1),style: TextStyle(fontSize: 50,color: Colors.white),),
              backgroundColor: Color(int.parse(profilecolor.toString())),
            ),
            SizedBox(height: 20),
            Text(disname.toString(),style: TextStyle(fontSize: 20),),
            SizedBox(height: 20),
            GestureDetector(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width *3/4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("My Blogs",style: TextStyle(fontSize: 25),),
                    ],
                  ),
              ),
                ),),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>myblogs()));
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: IconButton(icon:Icon(Icons.bookmark,color:Color(0xff4f5d75)),onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>savedblogs()))
                      },),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        height: 100,
                        width: 100,
                      child: IconButton(icon:Icon(Icons.logout,color: Color(0xff4f5d75),),onPressed: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            content: Text("Do you want to log out?"),
                            actions: [
                              TextButton(onPressed: () async{
                                //await deleteme();
                                final prefs=await SharedPreferences.getInstance();
                                await prefs.remove("token");
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()), (route) => false);
                              }, child: Text("YES",style:TextStyle(color:tertiary(),fontWeight: FontWeight.bold))),
                              TextButton(onPressed: (){
                                Navigator.of(context).pop();
                              }, child: Text("NO",style:TextStyle(color:tertiary(),fontWeight: FontWeight.bold)))
                            ],
                          );
                        });

                      },),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(child: Image(image: AssetImage("images/abc.png")))
          ],
        )
      ),
      onPanUpdate: (details){
        if(details.delta.dx<0){
            Navigator.pop(context);
        }
      },
    );
  }

  @override
  void initState() {
    userfetchfunc();
    //usermodel user=new usermodel(disname!, photourl!);
  }

}

class myblogs extends StatefulWidget {
  const myblogs({Key? key}) : super(key: key);

  @override
  _myblogsState createState() => _myblogsState();
}

class _myblogsState extends State<myblogs> {
  bool _loading=true;
  List<blogmodel> mybloglist=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff50f0f),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:Icon(Icons.arrow_back)
        ),
      ),
      body:(_loading)?Center(child: CircularProgressIndicator(color: tertiary(),)):(mybloglist.isNotEmpty)?
      SingleChildScrollView(
        child:Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemCount: mybloglist.length,
                  itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    child:ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mybloglist.elementAt(index).title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 27.5,fontWeight: FontWeight.w500,fontFamily: 'Oswald'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.heart_fill,color: Color(0xfff50f0f),),
                                        SizedBox(width: 10,),
                                        Text(mybloglist.elementAt(index).likes.toString())
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.flag),
                                        SizedBox(width: 10,),
                                        Text(mybloglist.elementAt(index).report.toString())
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>blogdetail(mybloglist.elementAt(index),1))).then((value) => {
                        initState()
                      });
                  },
                );
              }),
            ),
          ],
        )
      ):
      Center(
        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("You haven't posted any Blogs😕"),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Card(
                        color: primary(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Add a Blog ❤️",style: TextStyle(color: secondary()),),
                              ),
                            ],
                          )),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>addblog())).then((value) => {
                          initState()
                        });
                      },
                    )
                  ],
                ),)
    );
  }
  mybloggetter() async{
    final prefs=await SharedPreferences.getInstance();
    String? uid=prefs.getString("id");
    // print("lksjflkjsdfljsd"+uid.toString());
    await myblogsfunc(uid.toString()).then((v){
    mybloglist=v;
      mounted?setState(() {
        _loading=false;
      }):null;
    });

  }
  @override
  void initState() {
    mybloggetter();
  }
}

class savedblogs extends StatefulWidget {
  const savedblogs({Key? key}) : super(key: key);

  @override
  _savedblogsState createState() => _savedblogsState();
}

class _savedblogsState extends State<savedblogs> {
  List<blogmodel> mysavedblogs=[];
  String banner="";
  bool _loading=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff50f0f),
        ),
        body:(_loading)?Center(child: CircularProgressIndicator(color: tertiary(),)):(banner!="No Saved blogs")?
        SingleChildScrollView(
            child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mysavedblogs.length,
                      itemBuilder: (BuildContext context,int index){
                        return GestureDetector(
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 3,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 100),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex:5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Color(int.parse(mysavedblogs.elementAt(index).authorurl)),
                                                child: Text(mysavedblogs.elementAt(index).authorname[0],style: TextStyle(color: Colors.white,fontSize: 22.5),),
                                              ),
                                              Expanded(

                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Text(
                                                    mysavedblogs.elementAt(index).title,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: TextStyle(fontSize: 17.5,fontFamily: 'Oswald'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(flex:1,child:IconButton(icon:Icon(Icons.clear),onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return AlertDialog(
                                        content: Text("Do you want to remove from bookmark"),
                                        actions: [
                                          TextButton(onPressed: () async{

                                           await removefromMybookmarks(mysavedblogs.elementAt(index).blogid).then((b){
                                             initState();
                                           });
                                           Navigator.pop(context);
                                          }, child: Text("Yes",style:TextStyle(color:tertiary(),fontWeight: FontWeight.bold))),
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text('No',style:TextStyle(color:tertiary(),fontWeight: FontWeight.bold)))
                                        ],
                                      );
                                    });
                                  },))
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>blogdetail(mysavedblogs.elementAt(index),0))).then((value) => {
                              initState()
                            });
                          },
                        );
                      }),
                ),
              ],
            )
        ):
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("No Bookmarks"),
            ],
          ),)
    );
  }
  savedblogfunc() async{
    mysavedblogs.clear();
    await mysavedblogsprofile()
    .then((v){
      if(v!=null) {
        mysavedblogs = v;
        setState(() {
          _loading = false;
        });
      }
      else{
        setState(() {
          banner="No Saved blogs";
          _loading=false;
        });
      }
    });

  }
  @override
  void initState(){
    setState(() {
      _loading=true;
    });
    savedblogfunc();
  }
}

class blogdetail extends StatefulWidget {
  final blogmodel blog;
  final int screen;
  const blogdetail(this.blog,this.screen,{Key? key}) : super(key: key);

  @override
  _blogdetailState createState() => _blogdetailState();
}

class _blogdetailState extends State<blogdetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff50f0f),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ConstrainedBox(
                      constraints:BoxConstraints(minHeight: MediaQuery.of(context).size.height * 3/4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.blog.title,
                            style: TextStyle(fontSize: 27.5,fontWeight: FontWeight.w500,fontFamily: 'Oswald')
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Text(widget.blog.content,
                              style: TextStyle(fontSize: 17.5,fontFamily: 'Oswald-Extra'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              onDoubleTap: (){
                print(MediaQuery.of(context).padding.bottom);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar:(widget.screen==1)?Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 65,
            width: 65,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () async {
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      content: Text("Do you want to delete this blog"),
                      actions: [
                        TextButton(child: Text("Yes",style:TextStyle(color:tertiary(),fontWeight: FontWeight.bold)),onPressed: () async {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>home()), (route) => false);
                          deletemyblog(widget.blog.blogid);
                        },),
                        TextButton(child: Text("No",style:TextStyle(color:tertiary(),fontWeight: FontWeight.bold)),onPressed: () async {
                          Navigator.pop(context);
                        },)
                      ],
                    );
                  });
                  // Obtain shared preferences.
                },
                backgroundColor: Color(0xfff50f0f),
                child: Icon(Icons.delete),),
            ),
          )
        ],):null,
    );
  }
}



// class googelsignin extends StatefulWidget {
//   const googelsignin({Key? key}) : super(key: key);
//
//   @override
//   _googelsigninState createState() => _googelsigninState();
// }
//
// class _googelsigninState extends State<googelsignin> {
//
//   GoogleSignInAccount? _user;
//
//   @override
//   Widget build(BuildContext context) {
//     ConfirmationResult? confirmationResult;
//     String mobileno="";
//     String otp="";
//     bool temp=false;
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//               onPressed: () async {
//                 UserCredential user= await  signInWithGoogle();
//                 print(user.user?.displayName);
//               },
//               child: Text("GOOGLE SIGN IN"),
//             ),
//             ElevatedButton(onPressed: (){
//               GoogleSignIn().signOut().then((value) => print("user signed out"));
//             }, child: Text("SIGN OUT")),
//         ],
//       ),),
//     );
//   }
//
// }