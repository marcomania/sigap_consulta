import 'package:fisi_army/models/beneficio.dart';
import 'package:fisi_army/utilities/rest_api.dart';
import 'package:flutter/material.dart';
import 'package:fisi_army/pages/login_page.dart';
import 'package:fisi_army/pages/recaudaciones_page.dart';
import 'package:fisi_army/utilities/constants.dart';

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
    _controller = TabController(length: 5, vsync: this);
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
                              data[index].tipo,
                              data[index].autorizacion,
                              data[index].condicion,
                              data[index].fecha);
                        });
                  } else {
                    return Align(
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

  Widget descuento(int benefOtorgado, String tipo, String autorizacion,
      String condicion, String fecha) {
    String condicionM = condicion.toUpperCase();
    return Card(
      elevation: 3,
      child: Row(
        children: <Widget>[
          Container(
            height: 125,
            width: 110,
            child: benefOtorgado == null
                ? Container()
                : Container(
                    color: kSecondaryColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          benefOtorgado.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 40),
                        ),
                        Text(
                          "DESCUENTO",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  autorizacion,
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
                SizedBox(
                  height: 13,
                ),
                Text(
                  tipo + '-' + condicionM,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  fecha,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget dato(String nombre, String valor) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(nombre,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500)),
        )
      ]),
      Row(children: <Widget>[
        Text(valor,
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
        Tab(text: "Repitencia"),
        Tab(text: "Otros pagos")
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
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipoRecaudacion: 1),
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipoRecaudacion: 2),
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipoRecaudacion: 3),
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipoRecaudacion: 4),
        RecaudacionesPage(idalumno: widget.codigoAlumno, tipoRecaudacion: 5)
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
