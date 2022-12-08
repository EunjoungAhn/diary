import 'package:diary/data/diary.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "diary.db";
  static final _databaseVersion = 1;
  static final diaryTable = "diary";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }
  // 앱이 처음 실행될때 데이터 베이스를 생성
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $diaryTable (
      date INTEGER DEFAULT 0,
      title String,
      memo String,
      image String
      status INTEGER DEFAULT 0,
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> insertDiary(Diary diary) async {
    Database db = await instance.database;

    // 해당 날짜에 대한 데이터를 미리 가져온다.
    List<Diary> d = await getDiaryByDate(diary.date);

    if(d.isEmpty) {
      // 새로 추가, id는 자동 생성
      Map<String, dynamic> row = {
        "title": diary.title,
        "date": diary.date,
        "image": diary.image,
        "memo": diary.memo,
        "status": diary.status,
      };
      // map 구조를 데이터 베이스에 넣기
      return await db.insert(diaryTable, row);
    }else{
      Map<String, dynamic> row = {
        "title": diary.title,
        "date": diary.date,
        "image": diary.image,
        "memo": diary.memo,
        "status": diary.status,
      };
      // 해당 아이디어의 정보를 수정, 없으면 새로운 아이디를 위가하여 위의 코드를 실행
      return await db.update(diaryTable, row, where: "date = ?", whereArgs: [diary.date]);
    }

  }

  Future<List<Diary>> getAllDiary() async {
    Database db = await instance.database;
    List<Diary> diarys = [];

    // diaryTable 있는 데이터를 다 가져와라
    var queries = await db.query(diaryTable);

    // 투두 리스트에 다 담아주고
    for(var q in queries){
      diarys.add(Diary(
        title: q["title"],
        date: q["date"],
        image: q["image"],
        memo: q["memo"],
        status: q["status"],
      ));
    }

    return diarys;
  }

  Future<List<Diary>> getDiaryByDate(int date) async {
    Database db = await instance.database;
    List<Diary> diarys = [];

    // diaryTable 있는 데이터를 다 가져와라
    var queries = await db.query(diaryTable, where: "date = ?", whereArgs: [date]);

    // 투두 리스트에 다 담아주고
    for(var q in queries){
      diarys.add(Diary(
        title: q["title"],
        date: q["date"],
        image: q["image"],
        memo: q["memo"],
        status: q["status"],
      ));
    }

    return diarys;
  }

}
