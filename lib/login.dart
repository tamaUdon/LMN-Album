import 'package:albumapp/colors.dart';
import 'package:albumapp/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {  

  String inputText = "";
  String showText = "";
  String tmpInputText = "";
  String loginPlaceholder = "Enter your passcord";
  String registerPlaceholder = "Enter new passcord";
  String confirmPlaceholder = "Enter passcord again to confirm";
  String errorPlaceholder = "Oops! An error occured... Please try again";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _registerFlg;
  Future<bool> _registerPassFlg;
  bool registerFlg;
  bool confirmFlg = false;
  bool errorFlg = false;

  Future<int> _getPass() async {
    Future<int> _pass;

    setState(() {
      _pass = _prefs.then((SharedPreferences prefs) {
        return (prefs.getInt('pass') ?? 0);
      });
    });
    return _pass;
  }

  Future<bool> _register() async {
    final SharedPreferences prefs = await _prefs;
    int pass;

    try {
      pass = int.parse(inputText);
    }catch (e){
      print(e.toString());
      return false;
    }

    setState(() {
      _registerFlg = prefs.setBool("registered", true).then((bool success) {
        return true;
      });
      _registerPassFlg = prefs.setInt("pass", pass).then((bool success) {
        print("register success");
        return true;
      });
    });

    print("return success:" + _registerPassFlg.toString());
    return _registerPassFlg;
  } 

  Future<void> _checkPass() async {
    if (registerFlg){
      // 登録済み - SharedPreferencesの中身と比較
      errorFlg = false;
      final int pass = await _getPass();
      if (inputText == pass.toString()){
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      }else{
        errorFlg = true;
      }
      setState(() {
        inputText = "";
        showText = "";
      });
    }else{
      // 未登録時 - 再度入力させてから登録
      print("未登録時");
       errorFlg = false;
      if (!confirmFlg){
        print("1回目");
        setState(() {
          tmpInputText = inputText;
          confirmFlg = true;
        });
      }else{
        print("2回目");
        setState(() {
          confirmFlg = false;
        });
        if (tmpInputText == inputText){
          // ok
          var res = await _register();
          if (res){
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  return HomePage();
                },
              ),
            );
          }
        }else{
          // ng
          setState(() {
            errorFlg = true;
          });
        }
      }
      setState(() {
        inputText = "";
        showText = "";
      });
    }
  }

  @override
  void initState() {
    print("init state");
    super.initState();
    _registerFlg = _prefs.then((SharedPreferences prefs) {
      registerFlg = (prefs.getBool('registered') ?? false);
      return registerFlg;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("login : build");
    return Scaffold(
      backgroundColor: kLightGreen,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          children: <Widget>[    
            SizedBox(height: 50),
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                // MARK: - アイコン
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Icon(
                  Icons.lock
                  ),
                ),
                // MARK: - タイトル
                Text(
                  'LeMoN',
                  style: Theme.of(context).textTheme.headline5,
                ),
                // テキスト
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: 
                    FutureBuilder<bool>(
                      future: _registerFlg,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return 
                                snapshot.data ? 
                                // 登録済み
                                Column(
                                  children: <Widget>[
                                    Text(
                                      inputText.isEmpty ? (errorFlg ? errorPlaceholder : loginPlaceholder) : showText,
                                      style: TextStyle(
                                        fontSize: 18.0,
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
                                // 未登録
                                : 
                                Column(
                                  children: <Widget>[
                                    Text(
                                      inputText.isEmpty ? (errorFlg ? errorPlaceholder : (confirmFlg ? confirmPlaceholder : registerPlaceholder)) : showText,
                                      style: TextStyle(
                                        fontSize: 18.0
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
                                );
                              }
                            }
                          }
                        )        
                      ),
                  
                // MARK: - 番号ボタン
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (var i = 0; i < 3; i++)
                    Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (var j = 0; j < 3; j++)
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                inputText += (1+j+(3*i)).toString();
                                showText += "*";
                              });
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Text(
                              (1+j+(3*i)).toString(),
                              style: TextStyle(
                                fontSize: 20,
                                //fontFamily: ,
                              ),
                            ),
                            padding: EdgeInsets.all(20.0),
                            shape: CircleBorder(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            inputText += 0.toString();
                            showText += "*";
                          });
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Text("0",
                          style: TextStyle(
                            fontSize: 20,
                            //fontFamily: ,
                          ),
                        ),
                        padding: EdgeInsets.all(20.0),
                        shape: CircleBorder(),
                      ),
                    )
                  ],
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('CANCEL'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      setState(() {
                        inputText = "";
                        showText = "";
                      });
                    },
                  ),
                    RaisedButton(
                      child: Text('NEXT'),
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: (){
                        _checkPass();
                      },
                    ),
                  ],
                ),
              ],
            )
          ]
        )
      )
    );
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}