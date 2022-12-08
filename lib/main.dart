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
    return Container();
  }

  Widget getHistoryPage(){
    return Container();
  }

  Widget getChartPage(){
    return Container();
  }
}
