import 'package:albumapp/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {  

  String inputText = "";
  String placeholder = "Enter your passcord";
  String showText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: showText.isEmpty ? 
                    Text(
                      placeholder,
                      style: TextStyle(
                        fontSize: 20.0
                      ),
                    ) 
                    : Text(
                    showText,
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  )
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              height: 10,
              thickness: 1,
              indent: 20,
              endIndent: 20,
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
                            inputText = (1+j+(3*i)).toString();
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
                        inputText = 0.toString();
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
                    // TODO: ここにパスコードチェックロジック
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}

class NumButtonController extends TextEditingController{
  String inputText = "";
  String showText = "";

  numButtonPressed(int number){
    showText += "*";
    inputText += number.toString();
  }

  @override
  clear(){
    inputText = "";
    showText = "";
  }

  register(){
    // TODO: not yet implement
    print("login text" + text);
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