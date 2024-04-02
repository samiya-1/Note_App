import 'package:flutter/material.dart';
import 'package:noteapp/controller/NotescreenController.dart';
import 'package:share_plus/share_plus.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      required this.title,
      required this.des,
      required this.date,
      required this.clrIndex,
      this.onDeletepress,
      this.onEditPress});
  final String title;
  final String des;
  final String date;
  final int clrIndex;
  final void Function()? onDeletepress;
  final void Function()? onEditPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: NoteScreenController.colorList[clrIndex],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Row(
                children: [
                  InkWell(onTap: onEditPress, child: Icon(Icons.edit)),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(onTap: onDeletepress, child: Icon(Icons.delete))
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(des),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(date),
              SizedBox(
                width: 20,
              ),
              InkWell(
                  onTap: () {
                    Share.share('$title\n$des');
                  },
                  child: Icon(Icons.share)),
            ],
          )
        ],
      ),
    );
  }
}
