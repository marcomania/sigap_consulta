import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/rest_api.dart';

class FilesPage extends StatelessWidget {
  final String idTipoGrado;
  final String anioIngreso;
  final String codAlumno;
  final String idRec;
  const FilesPage(
      {Key key, this.idTipoGrado, this.anioIngreso, this.codAlumno, this.idRec})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recaudacion $idRec'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          FutureBuilder<List<dynamic>>(
            future:
                ApiService.getFiles(idTipoGrado, anioIngreso, codAlumno, idRec),
            // initialData: InitialData,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                List<dynamic> data = snapshot.data;

                return buildList(context, data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildList(BuildContext context, List data) {
    return Wrap(
      runAlignment: WrapAlignment.start,
      spacing: 4,
      runSpacing: 4,
      children:
          data.map((item) => crearCard(item, context)).toList().cast<Widget>(),
    );
  }

  Widget crearCard(String url, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.25 - 3,
      width: MediaQuery.of(context).size.width * 0.25 - 3,
      child: Material(
        child: InkWell(
          onTap: () {
            launch(url);
          },
          child: Container(
            child: stripExtension(url) == '.jpeg' ||
                    stripExtension(url) == '.jpg' ||
                    stripExtension(url) == '.png' ||
                    stripExtension(url) == '.gif' ||
                    stripExtension(url) == '.svg'
                ? FadeInImage(
                    placeholder: AssetImage('assets/sigap.png'),
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  )
                : Image(
                    image: stripExtension(url) == '.pdf'
                        ? AssetImage('assets/types_files/type_pdf.png')
                        : AssetImage('assets/types_files/FileType.png')),
          ),
        ),
      ),
    );
  }

  String stripExtension(String str) {
    if (str == null) return null;

    if (str.lastIndexOf(".") != -1 && str.lastIndexOf(".") != 0) {
      return str.substring(str.lastIndexOf("."));
    }

    return null;
  }
}
