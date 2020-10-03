import 'package:albumapp/colors.dart';
import 'package:albumapp/show_diary.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math' as math;

import 'model/content.dart';
import 'model/dao.dart';
import 'edit_diary.dart';

class HomePage extends StatelessWidget {
  static const String _title = 'LeMoN';
  TabController controller;
  RefreshController _refreshController;
  List<Diary> listDiaries;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: StatefulHomePage(),
      );
    }
  }

class StatefulHomePage extends StatefulWidget{
  StatefulHomePage({Key key}) : super(key: key);

  @override
  _StatefulHomePageState createState() => 
    _StatefulHomePageState();
  }

class _StatefulHomePageState extends State<StatefulHomePage> with SingleTickerProviderStateMixin {
  TabController controller;
  RefreshController _refreshController;
  List<Diary> listDiaries;

  @override
  void initState() {
    listDiaries = [];
    //listDiaries.add(new Diary(0,'Add new Diary...',''));
    print("home: initState!"); 

    super.initState();

    _refreshController =
      RefreshController();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  // SharedPrefenrencesからユーザ情報を取得
  Future<String> getUserInfo() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String _userName = _pref.getString('user_name');
    if (_userName != null){
      return _userName;
    }else{
      return '';
    }
  }

  // ユーザ情報を登録
  void setUserInfo(String userName) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString('user_name', userName).then((bool success) => {
      if (!success){
        // TODO: 失敗ダイアログ出す
      }
    });
  }

  // // DBの初期化
  Future<List<Diary>> initializeDiary() async{
    print("initializeDiary!");
    print("現在のlistDiaries : " + listDiaries.toString());
    await DAO.initDB();

    if (listDiaries.length < 1)
    {
      listDiaries = [];
      var dr = await DAO.get5Diaries(0);
      _refreshController.requestLoading(needMove: false, duration: Duration(microseconds: 300), curve: Curves.linear);

      if (dr == null)
      {
        // 日記が登録されていない
        print("drもnull : listDiariesもnull");
        listDiaries.add(new Diary(0,'test',''));
        print("listDiariesにdummy追加しました");
        return listDiaries;

      }else{
        // 日記が登録されている
        listDiaries = dr;
        return listDiaries;
      }
    }else{
      return listDiaries;
    }
  }

  // 編集ボタンタップ
  void _onTapMore(Diary dr){
    _showCupertinoActionSheet(context, dr);
  }

  // 編集・削除アクションシート表示
  void _showCupertinoActionSheet(BuildContext context, Diary dr) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: Text("Select Your Action"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text("EDIT"), onPressed: ()  => { 
                Navigator.pop(context),
                _onTapEdit(dr),
              },
            ),
            CupertinoActionSheetAction(
               child: Text("DELETE"), onPressed: () => {
                _onTapDelete(context, dr, 'Do you really want to delete this diary?', ''),
               },
                isDestructiveAction: true,
              ),
          ],
          cancelButton: CupertinoActionSheetAction(child: Text("Cancel"), onPressed: () { Navigator.pop(context); },),
        );
      }
    );
  }

  // アクションシートの削除ボタンを選択
  void _onTapDelete(BuildContext context, Diary dr, String title, String msg){
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Delete"),
              isDestructiveAction: true,
              onPressed: () => _doDelete(context, dr),
            ),
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: () => _ontapCancel(context),
            ),
          ],
        );
      },
    );
  }

  // 削除実行
  void _doDelete(BuildContext context, Diary dr) async {
    await DAO.deleteDiary(dr.id);
    setState(() {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  // 削除キャンセル
  void _ontapCancel(BuildContext context){
    setState(() {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  // 編集ボタンタップ
  void _onTapEdit(Diary dr){
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context){
          return ModalDiaryDetail.construct(dr);
        },
        fullscreenDialog: true
      )
    );
  }

  // タブ切り替え
  void _onItemTapped(int index){
    setState(() {
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
    _showEditPage();
  }

  // マイページ編集画面
  Widget _showEditPage(){
    // ここでマイページを編集可能にする
    // User -> TextFFieldにする
    // Image -> Imagebuttonにする (オーバーレイで被せる)
  }

  // 読み込み
  void _onLoading() async{

    await Future.delayed(Duration(milliseconds: 1000));

    List<Diary> tList = await DAO.getDiaries();
    print("tList.length: " + tList.length.toString());
    print("listDiaries.length: " + listDiaries.length.toString());

    if (tList.length <= listDiaries.length-1){
      _refreshController.loadNoData();
      return;
    }

    List<Diary> dList = await DAO.get5Diaries(listDiaries.length);

    if (dList == null)
    {
      _refreshController.loadNoData();
    }else{
      // 日記の中身がある
      if(mounted)
          setState(() {
            listDiaries += dList;
          });
      _refreshController.loadComplete();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: kButtonColor,
        appBar: AppBar(
          centerTitle: true, 
          title: new Text(
            "LeMoN", 
            style: TextStyle(
              color: kBrown900,
              fontFamily: 'RobotoMono',
            )
          ),
          backgroundColor: kLightGreen,
        ),
        body: 
          IndexedStack(
            index: controller.index,
            children: <Widget>[
          SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context,LoadStatus mode){
                Widget body ;
                if(mode==LoadStatus.idle){
                  body =  Text("pull up load");
                }
                else if(mode==LoadStatus.loading){
                  body =  CupertinoActivityIndicator();
                }
                else if(mode == LoadStatus.failed){
                  body = Text("Load Failed!Click retry!");
                }
                else if(mode == LoadStatus.canLoading){
                    body = Text("release to load more");
                }
                else{
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child:body),
                );
              },
            ),
            controller: _refreshController,
            onLoading: _onLoading,
            child: ListView.builder(
                  itemBuilder: (c,i) => FutureProvider<Diary>(
                    create: (_) => initializeDiary().then((value) => value[i]),
                    initialData: new Diary(0, "Please add new diary!", ""),
                    child: _messageItem(),
                  ),
                  itemExtent: 100.0,
                  itemCount: listDiaries.length,
                ),
              ), 
              _myPageItem(size), 
            ],
          ),
          // 
          // マイページ
          //
          bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kLightGreen,
          selectedItemColor: kAccentBlue,
          unselectedItemColor: kShadowGreen,
          currentIndex: controller.index,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              title: Text('diary'),
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
              turns: controller.index == 0
                  ? angle.animate(animation)
                  : angle.animate(ReverseAnimation(animation)),
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: tween.animate(animation),
                child: child,
              ),
            );
          },
          child: controller.index == 0
            // ダイアリー一覧ページ表示時のFAB
            ? FloatingActionButton(
                heroTag: "diary_btn",
                backgroundColor: kLightYellow,
                foregroundColor: kBrown900,
                onPressed: _onDiaryCreateTapped,
                child: Transform.rotate(
                  child: Icon(Icons.add),
                  angle: math.pi / 2,
                ),
              )
            // マイページ表示時のFAB
            : FloatingActionButton(
                heroTag: "mypage_btn",
                backgroundColor: kLightYellow,
                foregroundColor: kBrown900,
                onPressed: _onEditMyPageTapped,
                child: Icon(Icons.edit),
              ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }

  Widget separatorItem() {
    return Container(
      height: 1,
      color: kButtonColor,
    );
  }

  // マイページ
  Widget _myPageItem(Size size){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: size.height/4),
                alignment: Alignment.center,
                color: Colors.amberAccent[100].withOpacity(0.5),
                child: Text('Hello'),
              ),
              new Align(
                alignment: Alignment.center,
                child: 
                Padding(
                padding: EdgeInsets.only(top: size.height/10),
                child: 
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('images/lemon.jpg'),
                      )
                    ),
                  ),
                ),
              )
            ]
          ),
          ///
          /// マイページの中身
          ///
          FutureProvider<List<Diary>>(
                create: (_) => initializeDiary(),
                initialData: new List<Diary>.empty(),
                child: _myPageContents(),
              ),
            ],
          )
        ); 
      }

  //　マイページ編集画面
  Widget _myPageEditItem(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Container(
              width: 180.0,
              height: 180.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('images/cafe.jpg'),
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: 
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                // アイコン変更ボタン
                FlatButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.face, 
                        color: kBrown900,
                      ),
                      Text(
                        'Set your icon',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: kBrown900,
                        ),
                      ),
                    ],
                  ),
                )
                // アイコン変更ボタンここまで
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            height: 10,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: 
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                // パスワード変更ボタン
                FlatButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.lock, 
                        color: kBrown900,
                      ),
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: kBrown900,
                        ),
                      ),
                    ],
                  ),
                )
                // パスワード変更ボタンここまで
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            height: 10,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ],
      )
    );
    // マイページ編集画面ここまで
  }

  // ダイアリー一覧画面
  Widget _messageItem() {
    final dr = Provider.of<Diary>(context);
    return Container(
      child: ListTile(
        leading: Icon(Icons.cake),
        title: Text(
          dr.title,
          style: TextStyle(
            color:kBrown900,
            fontSize: 18.0,
            fontStyle: FontStyle.italic
          ),
        ),
        subtitle: Text(dr.memo),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () => _onTapMore(dr),
        ),
        contentPadding: EdgeInsets.all(10.0),

        onTap: () {
          print("onTap called.");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return ModalDiaryShow(dr);
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

  Widget _myPageContents()
  {
    List<Diary> dr = Provider.of(context);
    DateTime _startDate =  dr[0] != null ? DateTime.parse(dr[0].date).toLocal() : DateTime.now();

    return 
    Container(child: 
      Column(children: <Widget>[ 
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.library_books),
                Text(
                  ' Diaries: ' + dr.length.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.calendar_today),
              Text(
                ' From: ' + '${_startDate.year}/${_startDate.month}/${_startDate.day}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          )
        ]
      )
    );   
  }
}