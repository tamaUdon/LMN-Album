import 'package:albumapp/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'model/content.dart';
import 'model/dummy_content_repository.dart';

import 'detail.dart';

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
  int _selectedIndex = 0;
  TabController controller;

  final diaries = ContentRepository.loadContents();
  //HomePage();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  // タブ切り替え
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: kButtonColor,
        appBar: AppBar(
          centerTitle: true, 
          title: new Text(
            "LeMoN", 
            style: TextStyle(color: kBrown900)
          ),
          backgroundColor: kLightGreen,
        ),
        body: 
        TabBarView(
          controller: controller,
          children: [
            // ダイアリーページ
            ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return separatorItem();
              },
              itemBuilder: (BuildContext context, int index) {
                return _messageItem(diaries[index], context);
              },
              itemCount: diaries.length,
            ),
            // 空ページ
            Center(child: Text('Empty Page')),
            // マイページ
            Center(child: Text('My Page')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kLightGreen,
          selectedItemColor: kAccentBlue,
          unselectedItemColor: kShadowGreen,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              title: Text('diary'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text(''), 
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
              turns: _selectedIndex == 0
                  ? angle.animate(animation)
                  : angle.animate(ReverseAnimation(animation)),
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: tween.animate(animation),
                child: child,
              ),
            );
          },
          child: _selectedIndex == 0
            // ダイアリー一覧ページ
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

Widget _messageItem(Diary diary, BuildContext context) {
  return Container(
    decoration: new BoxDecoration(
      border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
      color: kWhite
    ),
    child: ListTile(
      leading: Icon(Icons.cake),
      title: Text(
        diary.title,
        style: TextStyle(
          color:kBrown900,
          fontSize: 18.0
        ),
      ),
      subtitle: Text(diary.memo),
      trailing: Icon(Icons.more_vert),
      contentPadding: EdgeInsets.all(10.0),

      onTap: () {
        print("onTap called.");
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context){
        //       return ModalDiaryDetail();
        //     },
        //     fullscreenDialog: true
        //   )
        // );
      }, // タップ
      onLongPress: () {
        print("onLongTap called.");
      }, // 長押し
    ),
  );
}