import 'package:flutter/material.dart';
import "package:objectbox/objectbox.dart";
//import 'objectbox.g.dart';

// Diaryの種類でソートする機能が必要な場合
enum Sort { list, tile } 

// ダミーデータ
// class Diary {
//   const Diary({
//     //@required this.content,
//     @required this.id,
//     @required this.title,
//     @required this.memo,
//     @required this.date,
//     this.image,
//   })  : assert(id != null),
//         assert(title != null),
//         assert(memo != null),
//         assert(date != null);

//   //final Content content;
//   final int id;
//   final String title;
//   final String memo;
//   final Image image;
//   final DateTime date;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': this.id,
//       'title': this.title,
//       'memo': this.memo,
//       'date': this.date,
//       'image': this.image,
//     };
//   }
// }

@Entity()
class Diary {
    @Id()
    int id;
    String title;
    String memo;
    DateTime date;
    Image image;
    
    Diary(); 

    Diary.construct(this.title, this.memo, this.image){
      date = DateTime.now();
      print("constructed date: $date");
    }

    toString() => "Diary{id: $id, title: $title, memo: $memo, date: $date, image: $image}";
}
