import 'package:blogspotbit/apihandler.dart';
import 'package:blogspotbit/blogmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class detailedblog extends StatefulWidget {
  final blogmodel blog;
  const detailedblog(this.blog, {Key? key}) : super(key: key);

  @override
  State<detailedblog> createState() => _detailedblogState();
}

class _detailedblogState extends State<detailedblog> {
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
                            style: TextStyle(fontSize: 27.5,fontWeight: FontWeight.w500,fontFamily: 'Oswald'),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          // Linkify(
                          //     text: widget.blog.content,
                          //   onOpen: (l)async{
                          //     if(await canLaunchUrl(Uri.parse(l.url))) {
                          //       await launchUrl(Uri.parse(l.url));
                          //     }
                          //   },
                          // )
                          Text(widget.blog.content,
                            style: TextStyle(fontSize: 17.5,fontFamily: 'Oswald-Extra'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
