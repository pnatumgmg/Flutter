import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home : _JankenPage(),
    );
  }
}

class _JankenPage extends StatefulWidget {
  const _JankenPage({super.key});

  @override
  State<_JankenPage> createState() => __JankenPageState();
}

class __JankenPageState extends State<_JankenPage> {

  String myHand = "✊";
  int myHandNumber = 0;
  String computerHand = "✊";
  int computerHandNumber = 0;
  String result = "引き分け";

  void selectHand(String selectedHand) {
    myHand = selectedHand;
    if      ("✊" == selectedHand)   myHandNumber = 0;
    else if ("✌" == selectedHand)   myHandNumber = 1;
    else if ("✋" == selectedHand)   myHandNumber = 2;
    // print(selectedHand);
    generateComputerHand();
    judge();
    setState(() {});
  }

  void generateComputerHand(){
    final randomNumber = Random().nextInt(3);
    computerHandNumber = randomNumber;
    computerHand = randomNumberToHand(randomNumber);
  }

  String randomNumberToHand(int randomNumber){
      switch (randomNumber) {
      case 0: // 入ってきた値がもし 0 だったら。
        return '✊'; // ✊を返す。
      case 1: // 入ってきた値がもし 1 だったら。
        return '✌️'; // ✌️を返す。
      case 2: // 入ってきた値がもし 2 だったら。
        return '🖐'; // 🖐を返す。
      default: // 上で書いてきた以外の値が入ってきたら。
        return '✊'; // ✊を返す。（0, 1, 2 以外が入ることはないが念のため）
    }
  }

  void judge(){
    int resultNumber = (myHandNumber - computerHandNumber + 3) % 3;
    if      (resultNumber == 0)      result = "引き分け";
    else if (resultNumber == 1)      result = "負け";
    else if (resultNumber == 2)      result = "勝ち";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("じゃんけん"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result,
                style: TextStyle(
                  fontSize: 32,
                ),
                ),
              SizedBox(
                height: 64,
              ),

              Text(
                computerHand,
                style: TextStyle(
                  fontSize: 32,
                ),
                ),
              SizedBox(
                height: 64,
              ),


              Text(
                myHand,
                style: TextStyle(
                  fontSize: 32,
                ),
                ),
              SizedBox(height: 32,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      selectHand("✊");
                    }, 
                    child: Text("✊"),
                          ),
                  ElevatedButton(
                    onPressed: (){
                      selectHand("✌");
                    }, 
                    child: Text("✌"),
                          ),
                  ElevatedButton(
                    onPressed: (){
                      selectHand("✋");
                    }, 
                    child: Text("✋"),
                          ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}