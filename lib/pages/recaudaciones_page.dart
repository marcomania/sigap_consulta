import 'package:flutter/material.dart';
import 'package:fisi_army/models/recaudacionesAlumno.dart';
import 'package:fisi_army/utilities/rest_api.dart';
import 'package:fisi_army/utilities/constants.dart';
import 'package:fisi_army/pages/detallePago_2.dart';

import '../utilities/rest_api.dart';

class RecaudacionesPage extends StatelessWidget {
  final String idalumno;
  final int tipo_recaudacion;
  double pagado = 0.0;
  double costo = 0.0;
  RecaudacionesPage({Key key, this.idalumno, this.tipo_recaudacion})
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
            data.forEach((element) {
              if (element.cIdTipoRecaudacion == this.tipo_recaudacion) {
                this.costo = this.costo + element.importe;
                if (element.validado) {
                  //true
                  this.pagado = this.pagado + element.importe;
                }
              }
            });
            print("costo : " +
                this.costo.toString() +
                " pagado : " +
                this.pagado.toString());

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
    return Container(
        child: Column(
      children: [
        descuento(this.costo, this.pagado, this.costo - this.pagado),
        ListView.builder(
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
            })
      ],
    ));
  }

  Widget descuento(
    double costo,
    double total_cancelado,
    double deuda,
  ) {
    return Card(
      elevation: 3,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                orden('COSTO', '$costo'),
                orden('TOTAL CANCELADO', '$total_cancelado'),
                orden('DEUDA ACTUAL', '$deuda')
              ],
            ),
          )
        ],
      ),
    );
  }
}
Widget orden(String tipo,String data){
  return Container(
  child: Row(
    children: [
      Column(
        children: [
          Text(
            '$tipo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 17),
          )
        ],
      ),
      Column(
        children: [
          Text(
            'S/. $data',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 17,
              backgroundColor: Colors.blueAccent[300]),
          )
        ],
      )
    ]
  ),
  );
}
class CardWidget extends StatelessWidget {
  final RecaudacionesAlumno recaudacion;
  String num_idgrado(String id) {
    String num;
    if (id == 'DISI') {
      num = '01';
    } else if (id == 'GTIC') {
      num = '02';
    } else if (id == 'ISW') {
      num = '03';
    } else if (id == 'GIC') {
      num = '04';
    } else if (id == 'GTI') {
      num = '05';
    } else if (id == 'DGTI') {
      num = '06';
    } else if (id == 'SATD') {
      num = '07';
    } else if (id == 'ASTI') {
      num = '08';
    } else if (id == 'GPTI') {
      num = '09';
    } else if (id == 'GPGE') {
      num = '10';
    }
    return num;
  }

  const CardWidget({Key key, this.recaudacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*ApiService.getFiles(
        recaudacion.idTipGrado + recaudacion.siglaPrograma.split(" ").join(""),
        recaudacion.anioIngreso.split(" ").join(""),
        recaudacion.codAlumno + "-" + recaudacion.apeNom.split(" ").join(""));*/

    /* ApiService.getFiles(
        '01.DISI', '2020-1', '20207091-REYES.HUAMAN.ANITA.MARLENE');*/
    String cIdTipoRecaudacion = recaudacion.cIdTipoRecaudacion.toString();
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
                              child: Hero(
                                tag: recaudacion.idRec,
                                child: Image.asset(
                                  'assets/tipoConcepto${cIdTipoRecaudacion}.png'),
                              ),
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
                                    "${recaudacion.numero}",
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
                num_idgrado(recaudacion.siglaPrograma.split(" ").join("")) +
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
