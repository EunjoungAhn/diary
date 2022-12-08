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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {

            },
            child: Text("저장", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if(index == 0){
            return InkWell(
              child: Container(
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
          }else if(index == 1){
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(statusimg.length, (_index) {
                  return InkWell(
                    child: Container(
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
          
          return Container();
        },
        itemCount: 6,
      ),
    );
  }
}

