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
  List hits = [];

  Future<void> fetchImages(String text) async{
    Response response = await Dio().get(
      "https://pixabay.com/api/?key=44444193-7ee4c1f09606d21ec096c9681&q=$text&image_type=photo&per_page=100");
    hits = response.data["hits"];
    setState(() {});
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
        itemCount: hits.length,
        itemBuilder: (context,index){
          Map<String,dynamic> hit = hits[index];
          return InkWell(
            // onTap: () {
            onTap: () async{
              // 1 URLからDL
              Response response = await Dio().get(
                hit["webformatURL"],
              options: Options(responseType: ResponseType.bytes),
              );

              // 2 DLして保存
              Directory dir = await getTemporaryDirectory();
              File file = await File("${dir.path}/image.png").writeAsBytes(response.data);

              // シェアパッケージを呼び出して共有
              // 動画だと下記コードだがshare_plusの更新で使えなくなった
              // await Share.shareFiles([file.path]);
              // 詳細右記参照:https://zenn.dev/joo_hashi/articles/19550230e0d004
              Share.shareXFiles([XFile(file.path)], text: 'Great picture');
              
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  hit['previewURL'],
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
                        Text("${hit["likes"]}"),
            
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