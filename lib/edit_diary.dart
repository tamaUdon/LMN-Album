import 'dart:convert';
import 'dart:io';

import 'package:albumapp/colors.dart';
import 'package:albumapp/model/content.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState(){
    super.initState();
  }

  // 日記の通し番号取得
  Future<int> _getCurrentDiaryCount() async {
    Future<int> _counter;

    //setState(() {
      _counter = _prefs.then((SharedPreferences prefs) {
        return (prefs.getInt('counter') ?? 0);
      });
    //});
    return _counter;
  }

  // 日記の通し番号をカウントアップしてセット
  Future<bool> _addDiaryCounter() async {
    final SharedPreferences prefs = await _prefs;
    int _counter;
    Future<bool> _setSuccessFlg;

    try {
        _counter = await _getCurrentDiaryCount();
        _counter++;
    }catch (e){
      print(e.toString());
      return false;
    }

    setState(() {
      _setSuccessFlg = prefs.setInt("counter", _counter).then((bool success) {
        if (success){
          print("current diary id : " + _counter.toString());
          return true;
        }
        return false;
      });
    });

    return _setSuccessFlg;
  } 

  // ダイアリー保存
  Future<void> _onOKTapped() async {
    try {
      print("入力したタイトル: " + _titleController.text);
      print("入力したmemo: " + _memoController.text);
      print("INSERTします...");
      bool _success = await _addDiaryCounter();
      if (_success){
        int count = await _getCurrentDiaryCount();
        DAO.insertDiary(new Diary(count, _titleController.text, _memoController.text));
      }else{
        print("日記カウントアップに失敗しました");
        return;
        // TODO: ここでINSERT失敗ダイアログ
      }
    }catch(e){
      print("could not insert diary...");
      // TODO: ここでINSERT失敗ダイアログ
    }
    print("INSERT成功");
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
                // Padding(
                //   padding: EdgeInsets.only(top: 10.0),
                //   child: 
                //   Card(
                //     borderOnForeground: true,
                //     child: Center(
                //       child:
                //       _image == null
                //       // 画像ピッカーボタン
                //       ? ButtonBar(
                //         alignment: MainAxisAlignment.start,
                //           children: <Widget>[
                //             FlatButton(
                //               child: 
                //                 Text(
                //                   'Tap to select image',
                //                   style: TextStyle(
                //                     color: kBrown900,
                //                     fontWeight: FontWeight.w300,
                //                   ),
                //                 ),
                //               onPressed: setImage,
                //             )
                //           ],
                //         )
                //       // 画像選択後、画像表示する => 再選択可
                //       : ButtonBar(
                //           children: <Widget>[
                //             FlatButton(
                //               onPressed: setImage,
                //               child: Image.file(_image) 
                //             ),
                            
                //           ],
                //         ) 
                //     ),
                //   )
                // )
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