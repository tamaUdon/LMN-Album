

import 'dart:convert';
import 'dart:typed_data';

import 'package:albumapp/colors.dart';
import 'package:albumapp/model/content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

import 'edit_diary.dart';

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
  GradColors gradations = new GradColors();
  DateTime myDiaryDate;
  _ModalDiaryShowState(diary){
    myDiary = diary;
    myDiaryDate = DateTime.parse(myDiary.date);
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

  void _onTapEdit(){
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context){
          return ModalDiaryDetail.construct(widget.myDiary);
        },
        fullscreenDialog: true
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightGreen,
        iconTheme: IconThemeData(color: kBrown900),
        title: Container(
            child: Row(children: [
              Text(
                myDiary.title,
                style: TextStyle(color: kBrown900),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: _onTapEdit,
              ),
            ]
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: 
        Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              gradations.pairStore[widget.myDiary.id%5].base,
              gradations.pairStore[widget.myDiary.id%5].spread,
            ],
            stops: const [
              0.0,
              1.0,
            ],
          ),
        ),
      child: 
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
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
                      '${myDiaryDate.year}/${myDiaryDate.month}/${myDiaryDate.day} ${myDiaryDate.hour}:${myDiaryDate.second}:${myDiaryDate.millisecond}',
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
      )
    );
  }
}