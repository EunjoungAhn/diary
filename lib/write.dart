import 'package:diary/data/database.dart';
import 'package:diary/data/diary.dart';
import 'package:flutter/material.dart';

class DiaryWritePage extends StatefulWidget {

  final Diary diary;

  const DiaryWritePage({Key key, this.diary}) : super(key: key);

  @override
  State<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  int imgIndex = 0;

  List<String> images = [
    "assets/img/b1.jpg",
    "assets/img/b2.jpg",
    "assets/img/b3.jpg",
    "assets/img/b4.jpg",
  ];

  List<String> statusimg = [
    "assets/img/ico-weather.png",
    "assets/img/ico-weather_2.png",
    "assets/img/ico-weather_3.png",
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  // 데이터 베이스에 저장을 위해 선언
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.diary.title;
    memoController.text = widget.diary.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              // 내용 저장
              widget.diary.title = nameController.text;
              widget.diary.memo = memoController.text;
              await dbHelper.insertDiary(widget.diary);
              Navigator.of(context).pop();
            },
            child: Text("저장", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if(index == 0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text("${widget.diary.date}", style: TextStyle(fontSize: 20),),
            );
          }
          else if(index == 1){
            return InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                width: 100,
                height: 100,
                child: Image.asset(
                  widget.diary.image,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.diary.image = images[imgIndex];
                  imgIndex ++;
                  imgIndex = imgIndex % images.length;
                });
              },
            );
          }else if(index == 2){
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(statusimg.length, (_index) {
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      height: 70,
                      width: 70,
                      child: Image.asset(statusimg[_index], fit: BoxFit.contain,),
                      // 선택되었을때 표시 동그란 표시
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: _index == widget.diary.status ? Colors.blue : Colors.transparent),
                        borderRadius: BorderRadius.circular(100)
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        widget.diary.status = _index;
                      });
                    },
                  );
                }),
              ),
            );
          }
          else if (index == 3) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text("제목", style: TextStyle(fontSize: 20),),
            );
          }
          else if (index == 4) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
              ),
            );
          }
          else if (index == 5) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text("내용", style: TextStyle(fontSize: 20),),
            );
          }
          else if (index == 6) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: memoController,
                minLines: 10,
                maxLines: 20,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
              ),
            );
          }

          return Container();
        },
        itemCount: 7,
      ),
    );
  }
}

