import 'package:albumapp/colors.dart';
import 'package:flutter/material.dart';

import 'model/content.dart';
import 'model/dummy_content_repository.dart';

class HomePage extends StatelessWidget {

  final diaries = ContentRepository.loadContents();
  HomePage();

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
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return separatorItem();
          },
          itemBuilder: (BuildContext context, int index) {
            return _messageItem(diaries[index]);
          },
          itemCount: diaries.length,
        )
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

Widget _messageItem(Diary diary) {
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
      }, // タップ
      onLongPress: () {
        print("onLongTap called.");
      }, // 長押し
    ),
  );
}