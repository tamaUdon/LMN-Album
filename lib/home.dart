import 'package:albumapp/colors.dart';
import 'package:albumapp/show_diary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import 'dart:math' as math;

import 'model/content.dart';
import 'model/dummy_content_repository.dart';
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

class _StatefulHomePageState extends State<StatefulHomePage> with SingleTickerProviderStateMixin{
  //int _selectedIndex = 0;
  TabController controller;
  Future<Database> database;

  final diaries = ContentRepository.loadContents();
  //HomePage();

  @override
  void initState() {
    super.initState();

    initDB();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  // DB初期化
  void initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      Path.join(await getDatabasesPath(), 'my_diaries.db'), // DB名: my_diaries
      // When the database is first created, create a table to store diaries.
      onCreate: (db, version) {
        return db.execute( // TABLE名: diaries
          "CREATE TABLE diaries(id INTEGER PRIMARY KEY, title TEXT, memo TEXT, date TEXT, image TEXT)",
        );
      },
      version: 1,
    );
  }

  // INSERT
  Future<void> insertDiary(Diary diary) async {
    final Database db = await database;
    await db.insert(
      'diaries',
      diary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Diary>> getDiaries() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('diaries');

    // Convert the List<Map<String, dynamic> into a List<Diary>.
    return List.generate(maps.length, (i) {
      return Diary(
        title: maps[i]['name'],
        memo: maps[i]['age'],
        date: maps[i]['date'],
        image: maps[i]['image'],
      );
    });
  }

  // UPDATE
  Future<void> updateDiary(Diary diary) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'diaries',
      diary.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [diary.id],
    );
  }

  // DELETE
  Future<void> deleteDiary(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'diaries',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
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
          children: [
            // ダイアリーページ
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 0,
              shrinkWrap: true,
              children: List.generate(
                diaries.length, (index) {
                  return _messageItem(diaries[index], context);
                }
              ),
            ),// マイページ
            _myPageItem(size)
          ],
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
                backgroundColor: kLightYellow,
                foregroundColor: kBrown900,
                key: UniqueKey(),
                onPressed: _onDiaryCreateTapped,
                child: Transform.rotate(
                  child: Icon(Icons.add),
                  angle: math.pi / 2,
                ),
              )
            // マイページ表示時のFAB
            : FloatingActionButton(
                backgroundColor: kLightYellow,
                foregroundColor: kBrown900,
                key: UniqueKey(),
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
Widget _messageItem(Diary diary, BuildContext context) {
  return Container(
    decoration: new BoxDecoration(
      border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
      color: kWhite,
      image: DecorationImage(
        image: diary.image.image,
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(kMossGreen.withOpacity(0.5), BlendMode.saturation)
      ),
    ),
    child: ListTile(
      //leading: Icon(Icons.cake),
      //Image.asset('images/sample.jpg'),
      // title: Text(
      //   diary.title,
      //   style: TextStyle(
      //     color:kWhite,
      //     fontSize: 18.0,
      //     fontStyle: FontStyle.italic
      //   ),
      // ),
      //subtitle: Text(diary.memo),
      //trailing: Icon(Icons.more_vert),
      contentPadding: EdgeInsets.all(10.0),

      onTap: () {
        print("onTap called.");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return ModalDiaryShow(diary);
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