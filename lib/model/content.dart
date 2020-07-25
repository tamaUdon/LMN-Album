import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Diaryの種類でソートする機能が必要な場合
enum Sort { list, tile } 

class Diary {
  const Diary({
    //@required this.content,
    @required this.id,
    @required this.title,
    @required this.memo,
    @required this.date,
    this.image,
  })  : assert(id != null),
        assert(title != null),
        assert(memo != null),
        assert(date != null);

  //final Content content;
  final int id;
  final String title;
  final String memo;
  final Image image;
  final DateTime date;

  //String get assetName => '$id-0.jpg';
  //String get assetPackage => 'shrine_images';

  //@override
  //String toString() => "$name (id=$id)";
}