

import 'dart:convert';
import 'dart:typed_data';

import 'package:albumapp/colors.dart';
import 'package:albumapp/model/content.dart';
import 'package:flutter/material.dart';

import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class ModalDiaryShow extends StatefulWidget{
  Diary myDiary;
  ModalDiaryShow(Diary diary){
    myDiary = diary;
  }
  @override
  _ModalDiaryShowState createState() => _ModalDiaryShowState(myDiary);
}

class _ModalDiaryShowState extends State<ModalDiaryShow>{
  Diary myDiary;

  _ModalDiaryShowState(diary){
    myDiary = diary;
  }

  String _toFormattedDate(DateTime datetime){
    initializeDateFormatting("en");
    var formatter = new DateFormat('yyyy/MM/dd =E= HH:mm', "en");
    return formatter.format(datetime);
  }

  Image _convertBase64ToImage(String _base64){
    Uint8List bytes = new Base64Decoder().convert(_base64);
    return new Image.memory(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightGreen,
        iconTheme: IconThemeData(color: kBrown900),
        title: Text(
          myDiary.title,
          style: TextStyle(color: kBrown900),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: new BoxDecoration(
              //border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
              color: kWhite,
              image: DecorationImage(
                image: Image.asset('assets/bar.jpg').image, // TODO:　ダミーデータ差し替え
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.blueGrey.withOpacity(0.5), BlendMode.saturation)
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: 
            Center(
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    myDiary.memo,
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    //_toFormattedDate(myDiary.date),
                    myDiary.date,
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ]
              ),
            )
          )
        ],
      ),
    );
  }
}