import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> shareText(String text, BuildContext context) async {
  final box = context.findRenderObject() as RenderBox?;

  await Share.share(
    text,
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}

Future<void> shareVerseText(BuildContext context,
    {required String surahName,
    required int surahNumber,
    required int verseNumber,
    required String arabic,
    required String translation}) async {


  String shareTextString =
      "\u202D$surahName: $surahNumber   |   ${"Verse".tr}: $verseNumber                                           \n\n\n"
      " ﴿ $arabic ﴾\n\n"
      "\u202D$translation \n\n"
      "----------------------------------\n"
      "\u202D${"Download DEN ÄDLA KORANEN App:".tr} https://denadlakoranen.se/qr.html";






// Reset text direction


  await shareText(shareTextString, context);

  // await shareText(
  //     "\u202B$surahName\u202C: $surahNumber   |   ${"Verse".tr}: $verseNumber \n\n\n"
  //     "\u202B﴿ $arabic ﴾\u202C \n\n"
  //     "$translation \n\n"
  //     "${"Download DEN ÄDLA KORANEN App:".tr} \nhttps://denadlakoranen.se/qr.html",
  //     context);
}

Future<void> shareImage(XFile file, BuildContext context) async {
  final box = context.findRenderObject() as RenderBox?;
  await Share.shareXFiles(
    [file],
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}

Future<void> launchUrlInBrowser(Uri uri) async {
  await launchUrl(uri);
}
