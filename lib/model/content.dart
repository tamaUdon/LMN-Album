import 'package:flutter/material.dart';

// Diaryの種類でソートする機能が必要な場合
enum Sort { list, tile } 

class Diary {
    int id;
    String title;
    String memo;
    DateTime date;
    Image image;
    
    Diary({String title, String memo, DateTime date, String image}); 

    Diary.construct(this.title, this.memo, this.image){
      date = DateTime.now();
      print("constructed date: $date");
    }

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'date': date,
      'image': image,
    };
  }

  toString() => "Diary{id: $id, title: $title, memo: $memo, date: $date, image: $image}";
}
