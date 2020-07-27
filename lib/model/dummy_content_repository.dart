import 'package:flutter/material.dart';

import 'content.dart';

class ContentRepository{
  static List<Diary> loadContents(){
    final allContents = <Diary>[
      Diary(
        title: "Cafe",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/cafe.jpg'),
      ),
      Diary(
        title: "Sea",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/sea.jpg'),
      ),
      Diary(
        title: "Museum",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/museum.jpg'),
      ),
      Diary(
        title: "FootBall",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/studium.jpg'),
      ),
      Diary(
        title: "Bar",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/bar.jpg'),
      ),
      Diary(
        title: "Reading Book",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/reading_book.jpeg'),
      ),
    ];
    return allContents;
  }
}