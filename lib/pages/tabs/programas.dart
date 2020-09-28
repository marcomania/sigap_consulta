import 'package:flutter/material.dart';

import 'package:fisi_army/models/alumnoprograma.dart';
import 'package:fisi_army/pages/pagos_page.dart';
import 'package:fisi_army/utilities/rest_api.dart';
import 'package:fisi_army/utilities/constants.dart';

class ProgramasWidget extends StatelessWidget {
  final String dni;
  const ProgramasWidget({Key key, this.dni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programas Cursados'),
        backgroundColor: Colors.indigo[900],
      ),
      body: FutureBuilder<List<AlumnoPrograma>>(
        future: ApiService.fetchProgamas(dni),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AlumnoPrograma> data = snapshot.data;
            return buildList(context, data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(BuildContext context, List<AlumnoPrograma> programasData) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: programasData.length,
        itemBuilder: (context, index) {
          return CardWidget(programa: programasData[index]);
        });
  }
}

class CardWidget extends StatelessWidget {
  final AlumnoPrograma programa;

  const CardWidget({Key key, this.programa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipPath(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PagosPage(codigoAlumno: programa.codAlumno)),
            );
          },
          child: Container(
            height: 150,
            padding: EdgeInsets.only(
                left: kDefaultPadding * 1.5, // 15 padding
                top: kDefaultPadding // 5 top and bottom
                ),
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(color: Colors.green, width: .5))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 3, color: Colors.indigo[900]),
                    ),
                    child: Center(
                      child: Image.asset(
                          'assets/tipGrado${programa.idTipGrado}.png'),
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${programa.nomPrograma}",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.vpn_key,
                              color: kSecondaryColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${programa.codAlumno}",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 14,
                                    letterSpacing: .3)),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.school,
                              color: kSecondaryColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${programa.siglaProg}",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    //backgroundColor: Colors.black12,
                                    fontSize: 14,
                                    letterSpacing: .3)),
                          ],
                        ),
                        SizedBox(
                          height: 6,
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
                            Text("${programa.anioIngreso}",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 14,
                                    letterSpacing: .3)),
                          ],
                        ),
                      ],
                    ),
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
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            "${programa.codSitu.trim()}",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 1.5, // 30 padding
                            vertical: kDefaultPadding / 4, // 5 top and bottom
                          ),
                          decoration: BoxDecoration(
                            color: kDetail2,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(0),
                            ),
                          ),
                          child: Text(
                            "${programa.codPerm.trim()}",
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
    );
  }
}
