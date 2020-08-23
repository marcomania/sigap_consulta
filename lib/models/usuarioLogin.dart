class UsuarioLogin {
  final int idUsuario;
  final String userName;
  final String pass;
  final String codAlumno;
  final String apePaterno;
  final String apeMaterno;
  final String nomAlumno;
  final String dniM;
  final String mail;

  UsuarioLogin(
      {this.idUsuario,
      this.userName,
      this.pass,
      this.codAlumno,
      this.apePaterno,
      this.apeMaterno,
      this.nomAlumno,
      this.dniM,
      this.mail});

  factory UsuarioLogin.fromJson(Map<String, dynamic> json) {
    return UsuarioLogin(
      idUsuario: json['idUsuario'] as int,
      userName: json['userName'] as String,
      pass: json['pass'] as String,
      codAlumno: json['codAlumno'] as String,
      apePaterno: json['apePaterno'] as String,
      apeMaterno: json['apeMaterno'] as String,
      nomAlumno: json['nomAlumno'] as String,
      dniM: json['dniM'] as String,
      mail: json['correo'] as String,
    );
  }
}
