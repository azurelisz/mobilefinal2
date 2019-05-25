import 'package:sqflite/sqflite.dart';

final String userTable = "user";
final String idCol = "_id";
final String useridCol = "userid";
final String nameCol = "name";
final String ageCol = "age";
final String passwordCol = "password";
final String quoteCol = "quote";

class User {
  int id;
  String userid;
  String name;
  String age;
  String password;
  String quote;

  User();

  User.formMap(Map<String, dynamic> map) {
    this.id = map[idCol];
    this.userid = map[useridCol];
    this.name = map[nameCol];
    this.age = map[ageCol];
    this.password = map[passwordCol];
    this.quote = map[quoteCol];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      useridCol: userid,
      nameCol: name,
      ageCol: age,
      passwordCol: password,
      quoteCol: quote,
    };
    if (id != null) {
      map[idCol] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'id: ${this.id}, userid:  ${this.userid}, name:  ${this.name}, age:  ${this.age}, password:  ${this.password}, quote:  ${this.quote}';
  }
}

class UserUtils {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $userTable (
        $idCol integer primary key autoincrement,
        $useridCol text not null unique,
        $nameCol text not null,
        $ageCol text not null,
        $passwordCol text not null,
        $quoteCol text
      )
      ''');
    });
  }

  Future<User> insertUser(User user) async {
    user.id = await db.insert(userTable, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(userTable,
        columns: [
          idCol,
          useridCol,
          nameCol,
          ageCol,
          passwordCol,
          quoteCol
        ],
        where: '$idCol = ?',
        whereArgs: [id]);
    return maps.length > 0 ? new User.formMap(maps.first) : null;
  }
//delete user
  Future<int> deleteUser(int id) async {
    return await db.delete(userTable, where: '$idCol = ?', whereArgs: [id]);
  }
//update user
  Future<int> updateUser(User user) async {
    return db.update(userTable, user.toMap(),
        where: '$idCol = ?', whereArgs: [user.id]);
  }
//get users
  Future<List<User>> getAllUser() async {
    await this.open("user.db");
    var res = await db.query(userTable, columns: [
      idCol,
      useridCol,
      nameCol,
      ageCol,
      passwordCol,
      quoteCol
    ]);
    List<User> userList =
        res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
    return userList;
  }
  Future close() async => db.close();
}
