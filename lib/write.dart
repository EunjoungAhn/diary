import 'package:diary/data/diary.dart';
import 'package:flutter/material.dart';

class DiaryWritePage extends StatefulWidget {

  final Diary diary;

  const DiaryWritePage({Key key, this.diary}) : super(key: key);

  @override
  State<DiaryWritePage> createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
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
    );
  }
}

