import 'package:fisi_army/pages/files_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
//import 'package:flutter/material.dart';

import 'package:fisi_army/models/recaudacionesAlumno.dart';

import 'pagos_page.dart';
import 'recaudaciones_page.dart';

class DetallePage extends StatefulWidget {
  final RecaudacionesAlumno recaudacion;

  const DetallePage({Key key, this.recaudacion}) : super(key: key);

  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  static final String uploadEndPoint =
      'https://vidco-consultarecibos-back.herokuapp.com/v1/storage/uploadFile/';
  Future<File> file;

  String status = '';

  String base64Image;

  File tmpFile;

  String errMessage = 'Error Subiendo';

  String extensionFile = '';

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    // return Container(
    //     child: Center(
    //   child: Text("${recaudacion.descripcionRecaudacion}"),
    // ));
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
      body: Container(
          child: Column(children: <Widget>[
        SizedBox(
          height: 20,
        ),
        mostrarDetallesRecaudacion(_screenSize),
        Expanded(child: SizedBox()),
        Row(
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
            Expanded(child: SizedBox()),
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
            Expanded(child: SizedBox()),
          ],
        ),
        Expanded(child: SizedBox()),
        mostrarFile(),
        Expanded(child: SizedBox()),
        Text(
          status,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Expanded(child: SizedBox()),
      ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.folder_open),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilesPage(
                      idTipoGrado: widget.recaudacion.idTipGrado +
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
    );
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
    if (str == null) return null;

    if (str.lastIndexOf(".") != -1 && str.lastIndexOf(".") != 0) {
      return str.substring(str.lastIndexOf("."));
    }
  }

  Future uploadImage() async {
    var stream = new http.ByteStream(tmpFile.openRead());
    stream.cast();
    var length = await tmpFile.length();

    String urii = (widget.recaudacion.idTipGrado +
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
        filename: basename(tmpFile.path));

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

  mostrarDetallesRecaudacion(Size screenSize) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: screenSize.height * 0.40,
        width: screenSize.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          /*boxShadow: [
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
          ],*/
        ),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Codigo del Alumno :'),
              subtitle: Text('${widget.recaudacion.codAlumno}'),
            ),
            Divider(),
            ListTile(
              title: Text('Nombre y Apellido :'),
              subtitle: Text('${widget.recaudacion.apeNom}'),
            ),
            Divider(),
            ListTile(
              title: Text('Concepto :'),
              subtitle: Text('${widget.recaudacion.concepto}'),
            ),
            Divider(),
            ListTile(
              title: Text('Recaudacion ID :'),
              subtitle: Text('${widget.recaudacion.idRec}'),
            ),
          ],
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------

class CardFile extends StatelessWidget {
  String pathFile;
  // File imagenFile;
  Image imagenFile;

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
