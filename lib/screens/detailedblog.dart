import 'package:blogspotbit/apihandler.dart';
import 'package:blogspotbit/blogmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                            style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Text(widget.blog.content,
                            style: TextStyle(fontSize: 20),
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
      bottomNavigationBar:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.share),
          Icon(Icons.bookmark_border_outlined),
          Icon(CupertinoIcons.heart)
        ],
      ),
    );
  }
}
