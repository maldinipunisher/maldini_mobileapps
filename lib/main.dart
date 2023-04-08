import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maldini_mobileapps/views/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 764),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          theme: ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              )),
          home: const DashboardPage(),
        );
      },
    );
  }
}
