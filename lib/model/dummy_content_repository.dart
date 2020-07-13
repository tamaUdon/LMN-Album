import 'content.dart';

class ContentRepository{
  static List<Diary> loadContents(){
    const allContents = <Diary>[
      Diary(
        id: 0,
        title: "Cafe",
        memo: "I had a fun time!"
      ),
      Diary(
        id: 0,
        title: "Sea",
        memo: "I had a fun time!"
      ),
      Diary(
        id: 1,
        title: "Museum",
        memo: "I had a fun time!"
      ),
      Diary(
        id: 2,
        title: "FootBall",
        memo: "I had a fun time!"
      ),
      Diary(
        id: 3,
        title: "Bar",
        memo: "I had a fun time!"
      ),
      Diary(
        id: 4,
        title: "Reading Book",
        memo: "I had a fun time!"
      ),
    ];
    return allContents;
  }
}