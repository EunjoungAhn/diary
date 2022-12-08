import 'package:diary/data/database.dart';
import 'package:diary/data/diary.dart';
import 'package:diary/data/util.dart';
import 'package:diary/write.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  // 캘린더를 사용하기 위한 컨트롤러 설정
  CalendarController calendarController = CalendarController();
  // 이전 날짜를 가져오기 위한 변수
  DateTime time = DateTime.now();

  // DB에 저장된 값 가져오기 위해 설정
  final dbHelper = DatabaseHelper.instance;
  Diary todayDiary;
  // 기록 페이지에서 선택된 날짜의 다이어리가 보여야 함으로
  Diary historyDiary;

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
      body: Container(
        child: getPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(selectIndex == 0){
            Diary _d;
            if(todayDiary != null){
              _d = todayDiary;
            }else{
              _d = Diary(
                  date: Utils.getFormatTime(DateTime.now()),
                  title: "",
                  memo: "",
                  status: 0,
                  image: "assets/img/b1.jpg"
                  );
            }
             await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiaryWritePage(
                diary: _d,
              )));
             getTodayDiary();
          }
          else {
            Diary _d;
            if(todayDiary != null){
              _d = todayDiary;
            }else{
              _d = Diary(
                  date: Utils.getFormatTime(time),
                  title: "",
                  memo: "",
                  status: 0,
                  image: "assets/img/b1.jpg"
              );
            }
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiaryWritePage(
              diary: _d,
            )));
            getDiaryByDate(time);
          }
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
        currentIndex: selectIndex,
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${DateTime.now().month}.${DateTime.now().day}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                        color: Colors.white),),
                        Image.asset(statusimg[todayDiary.status], fit: BoxFit.contain,)
                      ],
                    ),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todayDiary.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Container(height: 12,),
                        Text(todayDiary.memo, style: TextStyle(fontSize: 18),),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  void getDiaryByDate(DateTime date) async {
    // DB에서 날짜를 숫자 형태로 가져와라
    List<Diary> d = await dbHelper.getDiaryByDate(Utils.getFormatTime(date));
    setState(() {
      if(d.isEmpty){
        historyDiary = null;
      }else{
        historyDiary = d.first;
      }
    });
  }

  Widget getHistoryPage(){
    return Container(
      child: ListView.builder(itemBuilder: (context, index) {
        if(index == 0){
          return Container(
            child: TableCalendar(
              calendarController: calendarController,
              onDaySelected: (date, events, holidays) {
                print(date);
                time = date;
                getDiaryByDate(date);
              },
            ),
          );
        }
        else if (index == 1){
          if(historyDiary == null){ return Container(); }

          return Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${time.month}.${time.day}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color: Colors.black),),
                    Image.asset(statusimg[historyDiary.status], fit: BoxFit.contain,)
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(historyDiary.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Container(height: 12,),
                    Text(historyDiary.memo, style: TextStyle(fontSize: 18),),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
        itemCount: 2,
      ),
    );
  }

  Widget getChartPage(){
    return Container();
  }
}
