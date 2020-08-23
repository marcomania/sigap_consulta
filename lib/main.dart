import 'package:fisi_army/pages/tabs/programas.dart';
import 'package:fisi_army/pages/login_page.dart';
import 'package:fisi_army/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'package:fisi_army/pages/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appTitle = 'SIGAP VIDCO 2020-I';

    return ChangeNotifierProvider<LoginState>(
      builder: (BuildContext context) => LoginState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) =>
              SplashScreen(), //RecaudacionesPage(idalumno: '17207064'),
          '/add': (BuildContext context) => ProgramasWidget(),
          '/login': (BuildContext context) => LoginPage()
        },
      ),
    );
  }
}
