

import 'dart:io';

import 'package:albumapp/colors.dart';
import 'package:albumapp/model/content.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';

class ModalDiaryDetail extends StatefulWidget{
  @override
  _ModalDiarydetailState createState() => _ModalDiarydetailState();
}

class _ModalDiarydetailState extends State<ModalDiaryDetail>{
  File _image;
  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
  }
  
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _onOKTapped(){
    // TODO: ここでダイアリー保存
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kBrown900),
        backgroundColor: kLightGreen,
        title: Text(
          'New Diary',
          style: TextStyle(color: kBrown900),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                // MARK: - タイトル入力欄
                new TextField(
                  enabled: true,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: 'Title'
                  ),
                ),
                // MARK: - テキストフィールド
                Card(
                  color: kLightGreen,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      maxLength: 100,
                      maxLines: 10,
                      decoration: InputDecoration.collapsed(hintText: "Enter your text here")
                    )
                  ),
                ),
                // MARK: - 画像ピッカー
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: 
                  Card(
                    borderOnForeground: true,
                    child: Center(
                      child:
                      _image == null
                      // 画像ピッカーボタン
                      ? ButtonBar(
                        alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              child: 
                                Text(
                                  'Tap to select image',
                                  style: TextStyle(
                                    color: kBrown900,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              onPressed: getImage,
                            )
                          ],
                        )
                      // 画像選択後、画像表示する => 再選択可
                      : ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              onPressed: getImage,
                              child: Image.file(_image) 
                            ),
                            
                          ],
                        ) 
                    ),
                  )
                )
              ]
            ),
            // OKボタン
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: 
                RaisedButton(
                  color: kLightYellow,
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: _onOKTapped,
                ),
            )
          ],
        ),
      ),
    );
  }
}