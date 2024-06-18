import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  Future<void> fetchImages() async{
    Response response = await Dio().get(
      "https://pixabay.com/api/?key=44444193-7ee4c1f09606d21ec096c9681&q=yellow+flowers&image_type=photo");
    hits = response.data["hits"];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //最初に一度だけ呼ばれる
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: hits.length,
        itemBuilder: (context,index){
          Map<String,dynamic> hit = hits[index];
          return Image.network(hit['previewURL']);
        }
      ),
    );
  }
}