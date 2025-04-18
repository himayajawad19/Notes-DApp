import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_dapp/screens/notesVm.dart';
import 'package:notes_dapp/utils/AppColors.dart';
import 'package:provider/provider.dart';

class Notesview extends StatelessWidget {
  Notesview({super.key});

  final List<Color> colorCycle = [
    Colors.teal,
    Colors.indigo,
    Colors.deepOrange,
  ];

  Color getColorForIndex(int index) {
    return colorCycle[index % colorCycle.length];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Notesvm>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "your notes",
                        style: TextStyle(
                          color: AppColors.accentColor2,
                          fontFamily: 'Goblin_One',
                          fontSize: 28.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => addNoteBox(context, vm),
                          );
                        },
                        backgroundColor: AppColors.secondaryColor,
                        mini: true,
                        child: Icon(
                          Icons.add,
                          color: AppColors.accentColor,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      border: Border(
                        bottom: BorderSide(width: 3, color: Colors.white),
                        right: BorderSide(width: 3, color: Colors.white),
                        top: BorderSide(width: 1, color: Colors.white),
                        left: BorderSide(width: 1, color: Colors.white),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 0.32,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        "all",
                        style: TextStyle(
                          color: AppColors.fontColor,
                          fontFamily: "Lexend",
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Today",
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontFamily: 'Goblin_One',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.notes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '6:22 pm',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white70,
                                  fontFamily: "Lexend",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: getColorForIndex(index),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              vm.notes[index].description,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white,
                                                fontFamily: "Lexend",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            child: Icon(
                                              Icons.edit,
                                              size: 16.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          InkWell(
                                            onTap:
                                                () => vm.deleteNote(
                                                  vm.notes[index].id,
                                                ),
                                            child: Icon(
                                              Icons.delete,
                                              size: 16.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        vm.notes[index].title,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget addNoteBox(BuildContext context, Notesvm vm) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Add Note',
        style: TextStyle(fontFamily: "Lexend", fontWeight: FontWeight.w300),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: vm.titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: vm.descriptionController,
              maxLines: 10,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String title = vm.titleController.text;
            String description = vm.descriptionController.text;
            vm.createNote(title, description);
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            // Delete action
            Navigator.of(context).pop(); // Close dialog
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
