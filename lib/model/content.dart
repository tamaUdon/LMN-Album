
// Diaryの種類でソートする機能が必要な場合
enum Sort { list, tile } 

class Diary {
    int id;
    String title;
    String memo;
    String date;
    
    Diary(int id, String title, String memo){
      this.id = id;
      this.title = title;
      this.date = DateTime.now().toIso8601String();
      this.memo = memo;
    }

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'date': date,
    };
  }

  toString() => "Diary{id: $id, title: $title, memo: $memo, date: $date}";
}
