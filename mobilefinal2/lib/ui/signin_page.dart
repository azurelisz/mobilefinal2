import 'package:flutter/material.dart';
import 'package:mobilefinal2/db/user_db.dart';
import 'package:mobilefinal2/utils/current.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  UserUtils user = UserUtils();
  final userid = TextEditingController();
  final password = TextEditingController();
  bool isValid = false;
  int formState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            Image.network(
              "https://images.unsplash.com/photo-1522251670181-320150ad6dab?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1366&q=80",
              width: 180,
              height: 180,
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "User Id",
                  icon: Icon(Icons.account_box, size: 40, color: Colors.grey),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("Login"),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {
                    if (userid == userList[i].userid &&
                        password == userList[i].password) {
                      Current.id = userList[i].id;
                      Current.userId = userList[i].userid;
                      Current.name = userList[i].name;
                      Current.age = userList[i].age;
                      Current.password = userList[i].password;
                      Current.quote = userList[i].quote;
                      this.isValid = true;
                      print("this user valid");
                      break;
                    }
                  }
                }

                if (this.formState != 2) {
                  Toast.show("Please fill out this form", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  this.formState = 0;
                } else {
                  this.formState = 0;
                  await isUserValid(userid.text, password.text);
                  if (!this.isValid) {
                    Toast.show("Invalid user or password", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                    userid.text = "";
                    password.text = "";
                  }
                }

                Future showAllUser() async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {
                    print(userList[i]);
                  }
                }

                showAllUser();
                print(Current.whoCurrent());
              },
            ),
            FlatButton(
              child: Container(
                child: Text("Register New User", textAlign: TextAlign.right),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/regis');
              },
              padding: EdgeInsets.only(left: 180.0),
            ),
          ],
        ),
      ),
    );
  }
}
