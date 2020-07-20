import 'package:albumapp/colors.dart';
import 'package:flutter/material.dart';

import 'model/content.dart';
import 'model/dummy_content_repository.dart';
import 'detail.dart';

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
            return _messageItem(diaries[index], context);
          },
          itemCount: diaries.length,
        ),
        floatingActionButton: Container(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
            onPressed: (){
              // TODO: do something
            },
            child: Icon(
              Icons.add,
              color: kBrown900,
              size: 30.0,
            ),
            backgroundColor: kLightYellow,
            ),
          ),
        ),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return ModalDiaryDetail();
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