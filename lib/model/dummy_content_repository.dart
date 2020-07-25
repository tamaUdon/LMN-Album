import 'package:flutter/material.dart';

import 'content.dart';

class ContentRepository{
  static List<Diary> loadContents(){
    final allContents = <Diary>[
      Diary(
        id: 0,
        title: "Cafe",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/cafe.jpg'),
      ),
      Diary(
        id: 0,
        title: "Sea",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/sea.jpg'),
      ),
      Diary(
        id: 1,
        title: "Museum",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/museum.jpg'),
      ),
      Diary(
        id: 2,
        title: "FootBall",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/studium.jpg'),
      ),
      Diary(
        id: 3,
        title: "Bar",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/bar.jpg'),
      ),
      Diary(
        id: 4,
        title: "Reading Book",
        memo: "I had a fun time!",
        date: DateTime.now(),
        image: Image.asset('images/reading_book.jpeg'),
      ),
    ];
    return allContents;
  }
}