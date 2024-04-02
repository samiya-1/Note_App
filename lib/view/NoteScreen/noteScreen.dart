import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/controller/NotescreenController.dart';
import 'package:noteapp/view/NoteScreen/widget/NoteCard.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController decsController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int selectedClrIndex = 0;
  @override
  void initState() {
    NoteScreenController.getInitKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView.separated(
        itemCount: NoteScreenController.notesListkeys.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 20,
          );
        },
        itemBuilder: (context, index) {
          final currentKey = NoteScreenController.notesListkeys[index];
          final currentelement = NoteScreenController.mybox.get(currentKey);
          return NoteCard(
            title: currentelement['title'],
            des: currentelement['des'],
            date: currentelement['date'],
            clrIndex: currentelement['colorIndex'],
            onDeletepress: () async {
             await NoteScreenController.deleteNote(currentKey);
              setState(() {});
            },
            onEditPress: () {
              titleController.text =
                  currentelement['title'];
              decsController.text =
                  currentelement['des'];
              dateController.text =
                  currentelement['date'];
              selectedClrIndex =
                 currentelement['colorIndex'];

              custombottomsheet(context: context, isEdit: true, currentKey: currentKey);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          decsController.clear();
          dateController.clear();
          selectedClrIndex = 0;
          custombottomsheet(context: context);
        },
        backgroundColor: Colors.lime,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> custombottomsheet(
      {required BuildContext context, bool isEdit = false, var currentKey}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, bottomSetState) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEdit ? "Update Note" : "Add Note",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Title",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(width: 2))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 4,
                      controller: decsController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Description",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(width: 2))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: dateController,
                      decoration: InputDecoration(
                          filled: true,
                          suffixIcon: InkWell(
                              onTap: () async {
                                final selectedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030));

                                if (selectedDate != null) {
                                  String formateddate =
                                      DateFormat("yMMMMd").format(selectedDate);
                                  dateController.text = formateddate.toString();
                                }
                                // final selectedTime = await showTimePicker(
                                //     context: context,
                                //     initialTime: TimeOfDay.now());
                                // dateController.text =
                                //     selectedTime.toString();
                                setState(() {});
                              },
                              child: Icon(Icons.calendar_month_rounded)),
                          fillColor: Colors.white,
                          hintText: "Date",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(width: 2))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                          4,
                          (index) => InkWell(
                                onTap: () {
                                  selectedClrIndex = index;
                                  bottomSetState(() {});
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selectedClrIndex == index
                                              ? 5
                                              : 0),
                                      borderRadius: BorderRadius.circular(10),
                                      color: NoteScreenController
                                          .colorList[index]),
                                ),
                              )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          child: InkWell(
                            onTap: () {
                              if (isEdit == true) {
                                NoteScreenController.editNote(
                                    currentKey: currentKey,
                                    title: titleController.text,
                                    des: decsController.text,
                                    date: dateController.text,
                                    clrIndex: selectedClrIndex);
                              } else {
                                NoteScreenController.addNote(
                                    title: titleController.text,
                                    des: decsController.text,
                                    date: dateController.text,
                                    clrIndex: selectedClrIndex);
                              }

                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Text(
                                isEdit == true ? "Edit" : "Add",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
        isScrollControlled: true,
        backgroundColor: Colors.grey.shade800);
  }
}
