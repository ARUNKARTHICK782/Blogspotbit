import 'dart:convert';

import 'package:blogspotbit/blogmodel.dart';
import 'package:blogspotbit/tempfile/tempdartfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_share_me/flutter_share_me.dart';




gettoken(String? email,String? password) async {
  tempclass obj=new tempclass();
  print("in get token"+email.toString());
  var prefs=await SharedPreferences.getInstance();
  var b={"email":email,"password":password};
  print(b);
  var res=await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/check"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': obj.str,
    },
    body: json.encode(b),
  );
  print(res.body);
  // String? token = res.headers['x-auth-token'];
  prefs.setString("token", res.body.toString());
  return res.body.toString();
}

mefunc() async{
  var prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var res=await http.get(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/me"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':ftoken!,
    },
  );
  var me=json.decode(res.body);
  print(me);
  prefs.setString("id", me["_id"]);
  prefs.setString("email", me['email']);
  prefs.setString('name',me['name']);
  prefs.setString("profile_color", me["profile_color"]);
  return me;
}

Future<void> addblogtodb(String title,String content,String userid) async {

  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var blog={"title" :title, "content" : content,"author_id":userid};
  // ,"report_reason":{
  // "Abusive":0,
  // "Irrelevant":0,
  // "Spam or Suspicious":0
  // }
  await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/add"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':ftoken.toString(),
    },
    body: json.encode(blog),
  ).then((value) =>
  {
    print(value.body)
  });
}

showblogs() async {
  var prefs=await SharedPreferences.getInstance();
  String token=prefs.getString("token").toString();
  var res=await http.get(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/show"),
      headers: <String,String>{
        'x-auth-token':token,
      }
  );
  print(res.statusCode);
  print(json.decode(res.body));
  var blogs=json.decode(res.body);
  if(blogs.toString() == "No blogs Found"){
    return "No Blogs Found";
  }
  List<blogmodel> finalblogs=[];
  for(var i in blogs){
      blogmodel blogslist=blogmodel.fromJson(i);
      finalblogs.add(blogslist);
      // blogmodel blog=new blogmodel(i._id, i.title, _content, _pubdate, _author, _likes)
      //print(i);
  }
  List<blogmodel> reversedList = new List.from(finalblogs.reversed);
  print("kjghk"+reversedList[0].title);
  return reversedList;
 // print(res.body);
}

returntoken(String? name,String? email,String? password,String? photourl) async{

  var user={"name":name,"email":email,"password":password,"url":photourl};
  var res=await http.post(Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/add/23233"),
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
    body:json.encode(user),
  );
  // var head=json.decode(res.headers);
  // var head=json.decode(res.headers.toString());
  //print(res.headers["x-auth-token"]);
  print("in return token"+res.headers["x-auth-token"].toString());
  return res.headers["x-auth-token"];
}

deleteme() async {
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  print("fjskdfjls"+ftoken.toString());
  var res=await http.get(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/delete"),
      headers: <String, String>{'x-auth-token':ftoken.toString(),}
  );
  print(res.body);
}

// sharedprefFunc(String uniquetoken) async {
//   print("unique toke"+uniquetoken);
//   final prefs = await SharedPreferences.getInstance();
//   var res=await http.get(
//       Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/me"),
//       headers: <String,String>{
//         'x-auth-token':uniquetoken
//       }
//   );
//   var me=json.decode(res.body);
//   print(me["_id"]);
//   prefs.setString("uid", me["_id"].toString());
//   prefs.setString("token", uniquetoken);
// }
//
// addlike(int blogid) async {
//   var res=await http.put(Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/like/$blogid"));
//   print(res.body);
// }
//
// removelike(int blogid) async {
//   var res=await http.put(Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/dislike/$blogid"));
//   print(res.body);
// }

addtomylikes(int blogid) async{
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var res=await http.put(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/liked/$blogid"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':ftoken.toString(),
      },
      body: json.encode({"_id":blogid})
  );
  print(res.body);
}

removefromMylikes(int blogid) async{
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var res=await http.put(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/rmliked/$blogid"),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':ftoken.toString()
      }
  );
  print("removefromMylikes"+res.body.toString());
}

mylikes() async {
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  print(prefs.getString("token"));
  var res=await http.get(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/me"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':ftoken.toString(),
      },
  );
  print(res.body);
  var response=json.decode(res.body);
  print(response["liked_blogs"]);
  return response["liked_blogs"].cast<int>();
}

myblogsfunc(String? uid) async{
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  List<blogmodel> returnlist=[];
  var res=await http.get(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/showmyblogs/$uid"),
    headers: <String,String>{
      'x-auth-token':ftoken.toString()
    }
  );
  print(res.body);
  var myblogs=json.decode(res.body);
  for (var i in myblogs){
    blogmodel blog=new blogmodel.fromJson(i);
    returnlist.add(blog);
  }
  print(res.body);
  return returnlist;
}

deletemyblog(int blogid) async{
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var res=await http.get(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/delete/$blogid"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':ftoken.toString(),
    },
  );
  print(res.body);
}

mybookmarks() async {
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var res=await http.get(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/me"),
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':ftoken.toString(),
    },
  );
  print(res.body);
  var response=json.decode(res.body);
  print("alkalalal");
  print(response["saved"]);
  List<dynamic> temp=response["saved"];

  return response["saved"].cast<int>();
}


addtomybookmarks(int blogid) async{
  print("in addtomybookmarks");
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var res=await http.put(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/saved/$blogid"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':ftoken.toString(),
      },
      body: json.encode({"_id":blogid})
  );
  print("added to my bookmarks");
  print(res.body);
}

removefromMybookmarks(int blogid) async{
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var res=await http.put(
      Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/rmsaved/$blogid"),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':ftoken.toString()
      }
  );
  print("removed to my bookmarks");
  print(res.body);
}

mysavedblogsprofile() async{
  List<blogmodel> returnlist=[];
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  print("in my saved blogs profile"+ftoken.toString());
  var res=await http.get(
      Uri.parse("http://blog-spot-bit-2022.herokuapp.com/api/blogs/showsavedblogs"),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':ftoken.toString()
      }
  );
  print("ldf"+res.body);
  if(res.body=="No Saved Blogs"){
    return;
  }
  var blogs=json.decode(res.body);
  print("QLKWJELKASDJFLKSD");
  print(blogs);
  for(var i in blogs){
    blogmodel blog=new blogmodel.fromJson(i);
    print(blog.title);
    returnlist.add(blog);
  }
  return returnlist;
  print(res.body);

}


report(int blogid,int a,int i,int s) async{
  var prefs=await SharedPreferences.getInstance();
  String t=await prefs.getString("token").toString();
  var ak={
    "report_reason":{
      "Abusive":a,
      "Irrelavent":i,
      "Spam":s
    }
  };
  var res=await http.put(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/report/$blogid"),
    headers:<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token':t,
    },
    body:json.encode(ak)
    );
  print("in report function"+res.body.toString());
}

share(int id) async{
  String msg ='https://blog-spot-bit-2022.herokuapp.com/api/blogs/blog/$id';
  String? response;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  response = await flutterShareMe.shareToWhatsApp(msg: msg);
  debugPrint(response);
}
