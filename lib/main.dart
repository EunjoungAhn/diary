import 'package:diary/data/database.dart';
import 'package:diary/data/diary.dart';
import 'package:diary/data/util.dart';
import 'package:diary/write.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectIndex = 0;

  List<String> statusimg = [
    "assets/img/ico-weather.png",
    "assets/img/ico-weather_2.png",
    "assets/img/ico-weather_3.png",
  ];

  // DB에 저장된 값 가져오기 위해 설정
  final dbHelper = DatabaseHelper.instance;
  Diary todayDiary;

  void getTodayDiary() async {
    List<Diary> diary = await dbHelper.getDiaryByDate(Utils.getFormatTime(DateTime.now()));
    if(diary.isNotEmpty){
      todayDiary = diary.first;
    }
    // 함수를 통해서 setState를 할 수 있지만 바로, initState에서는 setState를 할 수 없어서
    // 함수화로 만든 후, initState에 넣어주는 것이다.
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getTodayDiary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: getPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
           await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiaryWritePage(
              diary: Diary(
                date: Utils.getFormatTime(DateTime.now()),
                title: "",
                memo: "",
                status: 0,
                image: "assets/img/b1.jpg"
              ),
            )));
           getTodayDiary();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "오늘"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: "기록"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: "통계"
          ),
        ],
        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage(){
    if (selectIndex == 0){
      return getTodayPage();
    }else if (selectIndex == 1){
      return getHistoryPage();
    }else {
      return getChartPage();
    }
  }

  Widget getTodayPage(){
    if(todayDiary == null){
      return Container(
        child: Text("일기를 작성해 주세요."),
      );
    }
    return Container(
      child: Stack(
        children: [
          // 배경 이미지를 깔리위한 설정
          Positioned.fill(
              child: Image.asset(todayDiary.image, fit: BoxFit.cover,),
          ),
          // 배경위에 데이터를 표시하기 위해 설정
          Positioned.fill(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${DateTime.now().month}.${DateTime.now().day}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                      color: Colors.white),),
                      Image.asset(statusimg[todayDiary.status], fit: BoxFit.contain,)
                    ],
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget getHistoryPage(){
    return Container();
  }

  Widget getChartPage(){
    return Container();
  }
}
