import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {

  //はじめは空のリストを入れておく
  List<PixabayImage> pixabayImages = [];

  Future<void> fetchImages(String text) async{
    final Response response = await Dio().get(
      // "https://pixabay.com/api/?key=44444193-7ee4c1f09606d21ec096c9681&q=$text&image_type=photo&per_page=100"
      "https://pixabay.com/api" ,
      queryParameters : {
        "key"         : '44444193-7ee4c1f09606d21ec096c9681' ,
        "q"           : text ,
        "image_type"  : "photo" ,
        "per_page"    : 100,
      },
      );
    final List hits = response.data["hits"];
    pixabayImages = hits
    .map(
      (e){
        return PixabayImage.fromMap(e);
      },
    ).toList();
    setState(() {});
  }
  ///画像をシェアする
  Future<void> shareImage(String url) async {
    // 1 URLからDL
              final Response response = await Dio().get(
                url,
              options: Options(responseType: ResponseType.bytes),
              );

              // 2 DLして保存
              final Directory dir = await getTemporaryDirectory();
              final File file = await File("${dir.path}/image.png")
                  .writeAsBytes(response.data);

              // シェアパッケージを呼び出して共有
              // 動画だと下記コードだがshare_plusの更新で使えなくなった
              // await Share.shareFiles([file.path]);
              // 詳細右記参照:https://zenn.dev/joo_hashi/articles/19550230e0d004
              Share.shareXFiles([XFile(file.path)], text: 'Great picture');
  }

  @override
  void initState() {
    super.initState();
    //最初に一度だけ呼ばれる
    fetchImages("犬");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: "犬",
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true
          ),
          onFieldSubmitted: (text){
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          ),
        itemCount: pixabayImages.length,
        itemBuilder: (context,index){
          final pixabayImage = pixabayImages[index];
          return InkWell(
            // onTap: () {
            onTap: () async{
              shareImage(pixabayImage.webformatURL);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  pixabayImage.previewURL,
                  fit: BoxFit.fill,
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 14,
                        ),
                        Text("${pixabayImage.likes}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PixabayImage {
  
  final String webformatURL;
  final String previewURL;
  final int likes;

  PixabayImage({
    required this.webformatURL, 
    required this.previewURL, 
    required this.likes,
  });

  factory PixabayImage.fromMap(Map<String, dynamic> map){
    return PixabayImage(
      webformatURL: map["webformatURL"],
      previewURL: map["previewURL"], 
      likes: map["likes"]
    );
  }
}

