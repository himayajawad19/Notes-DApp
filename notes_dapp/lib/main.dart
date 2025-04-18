import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_dapp/screens/notesVm.dart';
import 'package:provider/provider.dart';
import 'package:notes_dapp/screens/notesView.dart';
// import 'package:notes_dapp/providers/notes_vm.dart'; // Make sure this path is correct for your Notesvm class

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Notesvm(), // Create an instance of your Notesvm class
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 720),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
    
          home: Notesview(),
        );
      },
    );
  }
}