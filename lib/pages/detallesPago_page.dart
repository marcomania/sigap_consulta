import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'package:fisi_army/models/recaudacionesAlumno.dart';
import 'package:fisi_army/utilities/arc_banner_image.dart';
import 'pagos_page.dart';
import 'package:fisi_army/pages/files_page.dart';
import 'package:fisi_army/utilities/constants.dart';
import 'package:fisi_army/utilities/rest_api.dart';

class DetallePage extends StatefulWidget {
  final RecaudacionesAlumno recaudacion;

  const DetallePage({Key key, this.recaudacion}) : super(key: key);

  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  static final String uploadEndPoint =
      '${URLS.BASE_URL}/v1/storage/uploadFile/';
  Future<File> file;

  String status = '';

  String base64Image;

  File tmpFile;

  String errMessage = 'Error Subiendo';

  String extensionFile = '';

  String numIdGrado(String id) {
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

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.recaudacion.nomPrograma,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.recaudacion.apeNom,
          style: TextStyle(
            fontSize: 16,
            //fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'DNI: ' + widget.recaudacion.dni,
          style: TextStyle(
            fontSize: 16,
            //fontWeight: FontWeight.bold,
          ),
        ),
        //SizedBox(height: 12.0),
        //Row(children: _buildCategoryChips(textTheme)),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Subir comprobante de recibo'),
        backgroundColor: Colors.indigo,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PagosPage(
                          codigoAlumno: widget.recaudacion.codAlumno,
                        )),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.folder_open),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilesPage(
                      idTipoGrado: numIdGrado(widget.recaudacion.siglaPrograma
                              .split(" ")
                              .join("")) +
                          '.' +
                          widget.recaudacion.siglaPrograma.split(" ").join(""),
                      anioIngreso:
                          widget.recaudacion.anioIngreso.split(" ").join(""),
                      codAlumno: widget.recaudacion.codAlumno +
                          "-" +
                          widget.recaudacion.apeNom.split(" ").join("."),
                      idRec: widget.recaudacion.idRec
                          .toString()
                          .split(" ")
                          .join(""),
                    )),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 140.0),
                  child: ArcBannerImage('assets/portada_fisi.jpg'),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  right: 16.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(4.0),
                        elevation: 2.0,
                        child: Hero(
                          tag: widget.recaudacion.idRec,
                          child: Image.asset(
                            'assets/tipoConcepto${widget.recaudacion.cIdTipoRecaudacion}.png',
                            fit: BoxFit.scaleDown,
                            width: 126.0,
                            height: 180.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(child: movieInformation),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            mostrarDetallesRecaudacion(_screenSize),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: SizedBox()),
                RaisedButton(
                  padding: EdgeInsets.all(15),
                  color: Colors.indigo,
                  onPressed: escogerFile,
                  shape: StadiumBorder(),
                  child: Container(
                    width: _screenSize.width * 0.38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.white,
                        ),
                        Text(
                          'Cargar Archivo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(15),
                  color: Colors.indigo,
                  onPressed: uploadImage,
                  shape: StadiumBorder(),
                  child: Container(
                    width: _screenSize.width * 0.38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.cloud_upload, color: Colors.white),
                        Text(
                          'Subir Archivo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            mostrarFile(),
            SizedBox(height: 100.0),
          ],
        ),
        //poner
      ),
    );
  }

  mostrarDetallesRecaudacion(Size screenSize) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipPath(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: Column(
            children: <Widget>[
              Container(
                //height: 65,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            color: _calcularColor(widget.recaudacion.validado),
                            width: 10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                                "Numero : ${widget.recaudacion.numero}",
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
                                Icons.description,
                                color: kSecondaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "Recaudación : ${widget.recaudacion.descripcionRecaudacion}",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      letterSpacing: .3)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.folder_shared,
                                color: kSecondaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "Codigo de Alumno : ${widget.recaudacion.codAlumno}",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      letterSpacing: .3)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.description,
                                color: kSecondaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "Ubicación : ${widget.recaudacion.descripcionUbi}",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      letterSpacing: .3)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.description,
                                color: kSecondaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "Tipo : ${widget.recaudacion.descripcionTipo}",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      letterSpacing: .3)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.comment,
                                color: kSecondaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "Observación : ${widget.recaudacion.observacion.trim()}",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      letterSpacing: .3)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.comment,
                                color: kSecondaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "Observación UPG : ${widget.recaudacion?.observacionUpg ?? ""}",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      letterSpacing: .3)),
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
                              Text("Fecha : ${widget.recaudacion.fecha}",
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
                          "CONCEPTO: ${widget.recaudacion.concepto.trim()}",
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
                          "S/. ${widget.recaudacion.importe.toStringAsFixed(2)}",
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
    );
  }

  Color _calcularColor(bool validado) {
    if (validado == true)
      return Colors.green;
    else
      return Colors.red;
  }

  escogerFile() {
    setState(() {
      //file = ImagePicker.pickImage(source: ImageSource.gallery);
      file = FilePicker.getFile();
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  String stripExtension(String str) {
    if (str == null) {
      return null;
    } else if (str.lastIndexOf(".") != -1 && str.lastIndexOf(".") != 0) {
      return str.substring(str.lastIndexOf("."));
    }

    return null;
  }

  Future uploadImage() async {
    var stream = new http.ByteStream(tmpFile.openRead());
    stream.cast();
    var length = await tmpFile.length();

    String urii =
        (numIdGrado(widget.recaudacion.siglaPrograma.split(" ").join("")) +
            '.' +
            widget.recaudacion.siglaPrograma.split(" ").join("") +
            '/' +
            widget.recaudacion.anioIngreso.split(" ").join("") +
            '/' +
            widget.recaudacion.codAlumno +
            "-" +
            widget.recaudacion.apeNom.split(" ").join(".") +
            '/' +
            widget.recaudacion.idRec.toString().split(" ").join(""));

    var uri = Uri.parse(uploadEndPoint + urii);
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: p.basename(tmpFile.path));

    request.files.add(multipartFile);

    var response = await request.send();
    //print(response.statusCode);
    String status1 =
        response.statusCode == 200 ? 'Subio con éxito' : 'no subio';
    setStatus(status1);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Widget mostrarFile() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          extensionFile = stripExtension(tmpFile.path);

          if (extensionFile == '.jpeg' ||
              extensionFile == '.jpg' ||
              extensionFile == '.png' ||
              extensionFile == '.gif' ||
              extensionFile == '.svg') {
            //base64Image = base64Encode(snapshot.data.readAsBytesSync());

            return CardFile(
              pathFile: tmpFile.path,
              imagenFile: Image.file(
                snapshot.data,
              ),
            );
            /*return Flexible(
              child: Image.file(
                snapshot.data,
                fit: BoxFit.fill,
              ),
            );*/
          } else if (extensionFile == '.pdf') {
            return CardFile(
                pathFile: tmpFile.path,
                imagenFile: Image.asset('assets/types_files/type_pdf.png'));
          } else if (extensionFile == '.doc' || extensionFile == '.docx') {
            return CardFile(
                pathFile: tmpFile.path,
                imagenFile: Image.asset('assets/types_files/FileType.png'));
          } else {
            return Text('No es un archivo compatible');
          }
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No ha seleccionado ningun archivo',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}

class CardFile extends StatelessWidget {
  final String pathFile;
  // File imagenFile;
  final Image imagenFile;

  CardFile({@required this.pathFile, this.imagenFile});
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
      ),

      // padding: EdgeInsets.all(10),
      height: _screenSize.height * 0.15,
      width: _screenSize.width * 0.90,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            //width: _screenSize.height * 0.15,
            //height: _screenSize.height * 0.15,
            child: Container(
              width: _screenSize.height * 0.15,
              height: _screenSize.height * 0.15,
              child: imagenFile,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ruta:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Text(
                  pathFile,
                  style: TextStyle(color: Colors.blueGrey[600]),
                  //overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
