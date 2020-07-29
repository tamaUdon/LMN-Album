import 'dart:convert';
import 'dart:io';

import 'package:albumapp/colors.dart';
import 'package:albumapp/model/content.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'model/dao.dart';

class ModalDiaryDetail extends StatefulWidget{
  @override
  _ModalDiarydetailState createState() => _ModalDiarydetailState();
}

class _ModalDiarydetailState extends State<ModalDiaryDetail>{
  File _image;
  final picker = ImagePicker();
  final _titleController = new TextEditingController();
  final _memoController = new TextEditingController();

  @override
  void initState(){
    super.initState();
  }
  
  Future setImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  // ダイアリー保存
  Future<void> _onOKTapped() async {
    String base64Image;
    // 画像変換
    if (_image != null){
      List<int> imageBytes = _image.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }else{
      File imageFile = new File('images/sea.jpg');
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }
    await DAO.insertDiary(new Diary(title: _titleController.text, memo: _memoController.text, image: base64Image));
    Navigator.of(context).pop(); // TODO: ここで戻った先のhome.dartに引数を渡して画面を再描画させる
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
                  controller: _titleController,
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
                      controller: _memoController,
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
                              onPressed: setImage,
                            )
                          ],
                        )
                      // 画像選択後、画像表示する => 再選択可
                      : ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              onPressed: setImage,
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