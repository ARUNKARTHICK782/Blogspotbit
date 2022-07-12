import 'dart:io';
import 'dart:typed_data';

import 'package:blogspotbit/apihandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

Future<void> onButtonTap(oldShare share,Uint8List comingfile) async {
  String msg =
      'Flutter share is great!!\n Check out full example at https://pub.dev/packages/flutter_share_me';
  String url = 'https://pub.dev/packages/flutter_share_me';
  final tempDir = await getTemporaryDirectory();
  final file = await new File('${tempDir.path}/image.jpg').create();
  file.writeAsBytesSync(comingfile);
  String? response;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  if (file != null) {
    response = await flutterShareMe.shareToWhatsApp(
        imagePath: file.path,
        fileType:FileType.image);
  } else {
    response = await flutterShareMe.shareToWhatsApp(msg: msg);
  }
  debugPrint(response);
}
