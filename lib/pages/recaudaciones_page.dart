import 'package:flutter/material.dart';
import 'package:fisi_army/models/recaudacionesAlumno.dart';
import 'package:fisi_army/utilities/rest_api.dart';
import 'package:fisi_army/utilities/constants.dart';
import 'package:fisi_army/pages/detallesPago_page.dart';

import '../utilities/rest_api.dart';
import '../utilities/rest_api.dart';
import '../utilities/rest_api.dart';

class RecaudacionesPage extends StatelessWidget {
  final String idalumno;
  final int tipo_recaudacion;

  const RecaudacionesPage({Key key, this.idalumno, this.tipo_recaudacion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: FutureBuilder<List<RecaudacionesAlumno>>(
        future: ApiService.fetchRecaudaciones(idalumno),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RecaudacionesAlumno> data = snapshot.data;
            return buildList(context, data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget buildList(
      BuildContext context, List<RecaudacionesAlumno> recaudacionesData) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: recaudacionesData.length,
        itemBuilder: (context, index) {
          if (recaudacionesData[index].cIdTipoRecaudacion ==
              this.tipo_recaudacion) {
            return CardWidget(recaudacion: recaudacionesData[index]);
          } else {
            return Divider(height: 2.0);
          }
        });
  }
}

class CardWidget extends StatelessWidget {
  final RecaudacionesAlumno recaudacion;

  const CardWidget({Key key, this.recaudacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*ApiService.getFiles(
        recaudacion.idTipGrado + recaudacion.siglaPrograma.split(" ").join(""),
        recaudacion.anioIngreso.split(" ").join(""),
        recaudacion.codAlumno + "-" + recaudacion.apeNom.split(" ").join(""));*/

    /* ApiService.getFiles(
        '01.DISI', '2020-1', '20207091-REYES.HUAMAN.ANITA.MARLENE');*/
    return Stack(
      children: [
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ClipPath(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetallePage(recaudacion: recaudacion)),
                );
              },
              child: Column(
                children: <Widget>[
                  Container(
                    //height: 65,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: _calcularColor(recaudacion.validado),
                                width: 10))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 3, color: Colors.indigo[900]),
                            ),
                            child: Center(
                              child: Image.asset(
                                  'assets/tipGrado${recaudacion.idTipGrado}.png'),
                            )),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(
                                    Icons.comment,
                                    color: kSecondaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${recaudacion.descripcion_recaudacion}",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.today,
                                    color: kSecondaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${recaudacion.fecha}",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 14,
                                          letterSpacing: .3)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 1.5, // 30 padding
                              vertical: kDefaultPadding / 4, // 5 top and bottom
                            ),
                            decoration: BoxDecoration(
                              color: kDetail1,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              "CONCEPTO: ${recaudacion.concepto.trim()}",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 1.5, // 30 padding
                              vertical: kDefaultPadding / 4, // 5 top and bottom
                            ),
                            decoration: BoxDecoration(
                              color: kDetail2,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              "S/. ${recaudacion.importe.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 3),
          child: FutureBuilder(
            future: ApiService.getFiles(
                recaudacion.idTipGrado +
                    '.' +
                    recaudacion.siglaPrograma.split(" ").join(""),
                recaudacion.anioIngreso.split(" ").join(""),
                recaudacion.codAlumno +
                    "-" +
                    recaudacion.apeNom.split(" ").join("."),
                recaudacion.idRec.toString().split(" ").join("")),
            // initialData: InitialData,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return Align(
                  alignment: Alignment.topRight,
                  child: ClipOval(
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: snapshot.data.length > 0
                            ? Colors.blueAccent
                            : Colors.redAccent,
                      ),
                      child: Center(
                        child: Text(
                          '${snapshot.data.length}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Align(
                    alignment: Alignment.topRight,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ));
              }
            },
          ),
        ),
      ],
    );
  }

  Color _calcularColor(bool validado) {
    if (validado == true)
      return Colors.green;
    else
      return Colors.red;
  }
}
