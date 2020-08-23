import 'package:fisi_army/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:fisi_army/models/usuarioLogin.dart';

class PerfilUsuario extends StatelessWidget {
  final UsuarioLogin usuario;

  const PerfilUsuario({Key key, this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text('DATOS PERSONALES'),
          backgroundColor: kPrimaryColor,
          //bottom: getTabBar(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            ListTile(
              title: Text("Nombre Completo",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(usuario.nomAlumno +
                  " " +
                  usuario.apePaterno +
                  " " +
                  usuario.apeMaterno),
              leading: Icon(Icons.person, color: kSecondaryColor),
            ),
            ListTile(
              title:
                  Text("Correo", style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(getEmail()),
              leading: Icon(Icons.email, color: kSecondaryColor),
            ),
            ListTile(
              title: Text("DNI", style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(usuario.dniM),
              leading: Icon(Icons.chrome_reader_mode, color: kSecondaryColor),
            )
          ],
        ),
      ),
    );
  }

  String getEmail() {
    if (usuario.mail == null)
      return "SIN CORREO ELECTRONICO";
    else
      return usuario.mail;
  }
}
