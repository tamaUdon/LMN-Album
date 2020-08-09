import 'package:albumapp/colors.dart';
import 'package:albumapp/show_diary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import 'dart:io' as Io;
import 'dart:math' as math;
import 'dart:convert';

import 'model/content.dart';
import 'model/dao.dart';
import 'edit_diary.dart';

class HomePage extends StatelessWidget {
  static const String _title = 'LeMoN';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: StatefulHomePage()
    );
  }
}

class StatefulHomePage extends StatefulWidget{
  StatefulHomePage({Key key}) : super(key: key);

  @override
  _StatefulHomePageState createState() => 
    _StatefulHomePageState();
  }

class _StatefulHomePageState extends State<StatefulHomePage> with SingleTickerProviderStateMixin {
  TabController controller;
  //Future<List<Diary>> listDiaries;
  //List<Diary> listDiaries;

  @override
  void initState() {
    print("home: initState!");
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  Future<List<Diary>> initializeDiary() async{
    print("initializeDiary!");
    await DAO.initDB();
    print(await DAO.getDiaries());
    List<Diary> listDiaries = await DAO.getDiaries();
    if (listDiaries.length != 0){
      return listDiaries;
    }
    return new List<Diary>.filled(1, new Diary(0,'Let\'s create new Diary!',''));
  }

  // タブ切り替え
  void _onItemTapped(int index){
    setState(() {
      //_selectedIndex = index;
      controller.index = index;
    });
  }

  // ダイアリー新規作成ボタンタップ
  void _onDiaryCreateTapped(){
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context){
          return ModalDiaryDetail();
        },
        fullscreenDialog: true
      )
    );
  }

  // マイページ編集ボタンタップ
  void _onEditMyPageTapped(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return null;
        },
        fullscreenDialog: true
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: kButtonColor,
        appBar: AppBar(
          centerTitle: true, 
          title: new Text(
            "LeMoN", 
            style: TextStyle(
              color: kBrown900,
              fontFamily: 'RobotoMono',
            )
          ),
          backgroundColor: kLightGreen,
        ),
        body: 
        TabBarView(
          controller: controller,
          children: 
            // ダイアリーページ
            // GridView.count(
            //   crossAxisCount: 3,
            //   crossAxisSpacing: 2,
            //   mainAxisSpacing: 0,
            //   shrinkWrap: true,
              // children: List.generate(
              //   listDiaries.length, (index) {
              //     return Container(
              //       child: GridTile(
              //         child: listDiaries[index].image,
              //         footer: Text(listDiaries[index].date),
              //       )
              //     );
              //   }
              // )
              <Widget>[
                FutureBuilder(
                  future: initializeDiary(),
                  builder: (context, AsyncSnapshot snapshot){
                    if (snapshot.hasData){
                      List<Diary> diary = snapshot.data as List<Diary>;
                      
                      // final diaries = List.generate(diary.length, (index) {
                      //   return diary[index].image;
                      // });
                        // final diary = snapshot.data.map<Diary>((document) {
                        //   try {
                        //   return List.generate(document.length, (index){
                        //     try {
                        //       return Diary(title: document[index].title, memo: document[index].memo, image: document[index].image);
                        //     }catch (e){
                        //       print("cannot generate Diary... : " + e);
                        //       return null;
                        //     }
                        //   });
                        //   }catch (e){
                        //     print("cannot generate List... : " + e);
                        //     return null;
                        //   }
                        // }).toList();
                        
                        //return diary;
                        var _items;
                        List.generate(diary.length, (index){
                          _items = _messageItem(diary[index], context);
                        });
                        return _items;
                    }else{
                      return Container(child: Center(child: Text('please add new diary...')));
                      // TODO: ダイアリーがない場合、作成を促すダイアログを出す
                    }
                  },
                ),// マイページ
            _myPageItem(size)
            ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kLightGreen,
          selectedItemColor: kAccentBlue,
          unselectedItemColor: kShadowGreen,
          currentIndex: controller.index,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(

              icon: Icon(Icons.format_list_bulleted),
              title: Text('diary'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('MyPage')
            )
          ],
        ),
        floatingActionButton: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final tween = TweenSequence([
              TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
              TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
            ]);
            final angle = Tween(begin: 0 / 360, end: -90 / 360);
            return RotationTransition(
              turns: controller.index == 0
                  ? angle.animate(animation)
                  : angle.animate(ReverseAnimation(animation)),
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: tween.animate(animation),
                child: child,
              ),
            );
          },
          child: controller.index == 0
            // ダイアリー一覧ページ表示時のFAB
            ? FloatingActionButton(
                heroTag: "diary_btn",
                backgroundColor: kLightYellow,
                foregroundColor: kBrown900,
                onPressed: _onDiaryCreateTapped,
                child: Transform.rotate(
                  child: Icon(Icons.add),
                  angle: math.pi / 2,
                ),
              )
            // マイページ表示時のFAB
            : FloatingActionButton(
                heroTag: "mypage_btn",
                backgroundColor: kLightYellow,
                foregroundColor: kBrown900,
                onPressed: _onEditMyPageTapped,
                child: Icon(Icons.edit),
              ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }
}
Widget separatorItem() {
  return Container(
    height: 10,
    color: kButtonColor,
  );
}

// マイページ
Widget _myPageItem(Size size){
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.height/4),
              alignment: Alignment.center,
              color: Colors.amberAccent[100].withOpacity(0.5),
              child: Text('Hello'),
            ),
            new Align(
              alignment: Alignment.center,
              child: 
              Padding(
              padding: EdgeInsets.only(top: size.height/10),
              child: 
                Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('images/lemon.jpg'),
                    )
                  ),
                ),
              ),
            )
          ]
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person),
                  Text(
                    ' User: marika',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.library_books),
                    Text(
                      ' Diaries: 6',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.calendar_today),
                  Text(
                    ' From: 2020/07/23',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ]
    ),
  );
}

//　マイページ編集画面
Widget _myPageEditItem(){
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Container(
            width: 180.0,
            height: 180.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/cafe.jpg'),
              )
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: 
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              // アイコン変更ボタン
              FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.face, 
                      color: kBrown900,
                    ),
                    Text(
                      'Set your icon',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: kBrown900,
                      ),
                    ),
                  ],
                ),
              )
              // アイコン変更ボタンここまで
            ],
          ),
        ),
        Divider(
          color: Colors.black,
          height: 10,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: 
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              // パスワード変更ボタン
              FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.lock, 
                      color: kBrown900,
                    ),
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: kBrown900,
                      ),
                    ),
                  ],
                ),
              )
              // パスワード変更ボタンここまで
            ],
          ),
        ),
        Divider(
          color: Colors.black,
          height: 10,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    )
  );
  // マイページ編集画面ここまで
}

// ダイアリー一覧画面
Widget _messageItem(Diary dr, BuildContext context) {
  return Container(
    child: ListTile(
      leading: Icon(Icons.cake),
      title: Text(
        dr.title,
        style: TextStyle(
          color:kBrown900,
          fontSize: 18.0,
          fontStyle: FontStyle.italic
        ),
      ),
      subtitle: Text(dr.memo),
      trailing: Icon(Icons.more_vert),
      contentPadding: EdgeInsets.all(10.0),

      onTap: () {
        print("onTap called.");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return ModalDiaryShow(dr);
            },
            fullscreenDialog: true
          )
        );
      }, // タップ
      onLongPress: () {
        print("onLongTap called.");
      }, // 長押し
    ),
  );
}