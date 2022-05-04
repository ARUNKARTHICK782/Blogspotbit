import 'dart:convert';

import 'package:blogspotbit/blogmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

gettoken(String? email,String? password) async {
  print("in get token"+email.toString());
  var prefs=await SharedPreferences.getInstance();
  var b={"email":email,"password":password};
  print(b);
  var res=await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/check"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
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
}

Future<void> addblogtodb(String title,String content,String userid) async {
  final prefs=await SharedPreferences.getInstance();
  String? ftoken=await prefs.getString("token");
  var blog={"title" :title, "content" : content,"author_id":userid};
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
  var res=await http.get(Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/show"));
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

addlike(int blogid) async {
  var res=await http.put(Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/like/$blogid"));
  print(res.body);
}

removelike(int blogid) async {
  var res=await http.put(Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/dislike/$blogid"));
  print(res.body);
}

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
        'x-auth-token':ftoken.toString()
      }
  );
  print(res.body);
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
  List<blogmodel> returnlist=[];
  var res=await http.get(Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/blogs/showmyblogs/$uid"));
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
    headers: <String, String>{
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
        'x-auth-token':ftoken.toString()
      }
  );
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


getotp(String? email, String? subject) async {

  var b={"email":email,"type":subject};

  var res=await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/send/email/otp"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(b),
  );

  var finaldetails = json.decode(res.body);

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
    },
    body: json.encode(b),
  );
  var finaldetails = json.decode(res.body);
  return finaldetails;
}

adduser(String? name, String? email, String? password, String? url) async {
  var prefs=await SharedPreferences.getInstance();
  var b={"name": name,"email":email,"password":password, "url": url};
  print(b);
  var res=await http.post(
    Uri.parse("https://blog-spot-bit-2022.herokuapp.com/api/users/add/8979"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(b),
  );
  print(res.body);
  String? token = res.headers['x-auth-token'];
  prefs.setString("token", token!);
  print("bala daw "+prefs.getString("token").toString());
  return res.body;
}