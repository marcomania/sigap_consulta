import 'dart:convert';

import 'package:fisi_army/models/beneficio.dart';
import 'package:fisi_army/utilities/rest_api.dart';
import 'package:flutter/material.dart';
import 'package:fisi_army/pages/login_page.dart';
import 'package:fisi_army/pages/recaudaciones_page.dart';
import 'package:http/http.dart' as http;

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
    debugPrint(widget.codigoAlumno);
    _controller = TabController(length: 3, vsync: this);
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
            FutureBuilder<List<Beneficio>>(
                initialData: [],
                future: ApiService.fetchBeneficio(widget.codigoAlumno),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Beneficio> data = snapshot.data;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (context, index) {
                          return descuento(
                              data[index].benefOtrogado,
                              data[index].autorizacion,
                              data[index].condicion,
                              data[index].fecha);
                        });
                  } else {
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("0 Descuentos",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20.0)),
                        ));
                  }
                }),
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

  Widget descuento(
      int benef_otrogado, String autorizacion, String condicion, String fecha) {
    return Stack(children: [
      Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[dato("BENEFICIO", "${benef_otrogado}%")]),
            SizedBox(height: 20),
            Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: dato("AUTORIZACIÓN", "${autorizacion}"),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: dato("CONDICIÓN", "${condicion}"),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: dato("FECHA", "${fecha}"),
              )
            ])
          ],
        ),
      ),
      ClipOval(
        child: Container(
          height: 5,
          width: 5,
          color: Colors.red,
        ),
      )
    ]);
  }

  Widget dato(String nombre, String valor) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text("${nombre}",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500)),
        )
      ]),
      Row(children: <Widget>[
        Text("${valor}",
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500))
      ])
    ]);
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(text: "UPG"),
        Tab(text: "EPG"),
        Tab(text: "Enseñanza"),
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
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipo_recaudacion: 1),
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipo_recaudacion: 2),
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipo_recaudacion: 3)
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
