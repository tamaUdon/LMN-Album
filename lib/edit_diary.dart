import 'dart:convert';
import 'dart:io';

import 'package:albumapp/colors.dart';
import 'package:albumapp/model/content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'home.dart';
import 'model/dao.dart';

class ModalDiaryDetail extends StatefulWidget{
  Diary dr;

  ModalDiaryDetail(){
    this.dr = null;
  }
  ModalDiaryDetail.construct(Diary dr){
    this.dr = dr;
  }

  @override
  _ModalDiarydetailState createState() => _ModalDiarydetailState();
}

class _ModalDiarydetailState extends State<ModalDiaryDetail>{
  final _titleController = new TextEditingController();
  final _memoController = new TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState(){
    super.initState();
    if (widget.dr != null){
      _titleController.text = widget.dr.title;
      _memoController.text = widget.dr.memo;
    }
  }

  // 削除ボタンを選択
  void _onTapDelete(BuildContext context, Diary dr, String title, String msg){
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Delete"),
              isDestructiveAction: true,
              onPressed: () => {
                _doDelete(context, dr),
                Navigator.of(context).pop(true),
              }
            ),
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: () => _ontapCancel(context),
            ),
          ],
        );
      },
    );
  }

  // 削除実行
  void _doDelete(BuildContext context, Diary dr) async {
    await DAO.deleteDiary(dr.id);
  }

  // 削除キャンセル
  void _ontapCancel(BuildContext context){
      Navigator.pop(context);
  }

  // 日記の通し番号取得
  Future<int> _getCurrentDiaryCount() async {
    Future<int> _counter;

    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
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

      if (widget.dr != null){
        print("UPDATEします...");
        await _doUpdate(widget.dr);
      }else{
        print("INSERTします...");
        await _doInsert();
      }

    }catch(e){
      print("INSERTもしくはUPDATEに失敗しました");
      // TODO: ここでINSERT失敗ダイアログ
    }
    print("INSERT or UPDATE 成功");

    Navigator.of(context).pop(true);
  }

  // 新規登録
  Future<void> _doInsert() async {
    bool _success = await _addDiaryCounter();
      if (_success){
        int count = await _getCurrentDiaryCount();
        await DAO.insertDiary(new Diary(count, _titleController.text, _memoController.text));
      }else{
        print("日記カウントアップに失敗しました");
        return;
        // TODO: ここでINSERT失敗ダイアログ
      }
  }

  // 編集内容を保存
  Future<void> _doUpdate(Diary dr) async {
    DAO.updateDiary(new Diary(dr.id, _titleController.text, _memoController.text));
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kBrown900),
        backgroundColor: kLightGreen,
        title: Container(
          child: 
            Row(children: <Widget>[
              Text(
                'New Diary',
                style: TextStyle(color: kBrown900),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => { 
                  _onTapDelete(
                    context, 
                    widget.dr, 
                    'Do you really want to delete this diary?', ''),
                }
              ),
            ]
          ),
        )
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
              ]
            ),
            // OKボタン
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: RaisedButton(
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
                onPressed: 
                  () => _onOKTapped(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}