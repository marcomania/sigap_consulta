import 'package:fisi_army/pages/tabs/epg.dart';
import 'package:fisi_army/pages/tabs/upg.dart';
import 'package:flutter/material.dart';
import 'package:fisi_army/pages/login_page.dart';
import 'package:fisi_army/pages/recaudaciones_page.dart';

class PagosPage extends StatefulWidget {
  final String codigoAlumno;

  const PagosPage({Key key, this.codigoAlumno}) : super(key: key);

  @override
  _PagosPageState createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    EpgWidget();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.codigoAlumno);
    return MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("PAGOS DEL PROGRAMA", style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.indigo[900],
        ),
        body: Column(
          children: <Widget>[
            descuento(),
            Container(
              padding: EdgeInsets.all(15),
              child: getTabBar(),
            ),
            Expanded(
              child: getTabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget descuento() {
    return Column(
      children: <Widget>[
        Container(
          child: Text("Descuento: ",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
          height: 40,
        )
      ],
    );
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          text: "UPG",
        ),
        Tab(text: "EPG")
      ],
      controller: _controller,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black54,
    );
  }

  TabBarView getTabBarView() {
    return TabBarView(
      controller: _controller,
      children: <Widget>[
        UpgWidget(),
        RecaudacionesPage(idalumno: widget.codigoAlumno)
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cancelButton = FlatButton(
      child: Text(
        "Seguir aqui",
        style: TextStyle(fontSize: 15.0),
      ),
      onPressed: () => Navigator.pop(context),
      color: Colors.indigo,
    );
    Widget okButton = FlatButton(
      child: Text(
        "Cerrar Sesion",
        style: TextStyle(fontSize: 15.0),
      ),
      onPressed: () => {
        Navigator.pop(context),
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        )
      },
      color: Colors.redAccent,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cerrar Sesion"),
      content: Text("Esta Seguro que desea cerrar sesion?"),
      actions: [okButton, cancelButton],
      elevation: 24.0,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
