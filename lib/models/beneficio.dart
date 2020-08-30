class Beneficio {
  final String codAlumno;
  final int idBeneficio;
  final int benefOtrogado;
  final String benefMax;
  final String tipo;
  final String autorizacion;
  final String resolucion;
  final int idBc;
  final String condicion;
  final String fecha;
  final int idAbp;
  final String criterio;
  final String observacion;

  Beneficio(
      {this.codAlumno,
      this.idBeneficio,
      this.benefOtrogado,
      this.benefMax,
      this.tipo,
      this.autorizacion,
      this.resolucion,
      this.idBc,
      this.condicion,
      this.fecha,
      this.idAbp,
      this.criterio,
      this.observacion});

  factory Beneficio.fromJson(Map<String, dynamic> json) {
    return Beneficio(
      codAlumno: json['cod_alumno'] as String,
      idBeneficio: json['id_beneficio'] as int,
      benefOtrogado: json['benef_otrogado'] as int,
      benefMax: json['benef_max'] as String,
      tipo: json['tipo'] as String,
      autorizacion: json['autorizacion'] as String,
      idBc: json['id_bc'] as int,
      condicion: json['condicion'] as String,
      fecha: json['fecha'] as String,
      idAbp: json['id_abp'] as int,
      criterio: json['criterio'] as String,
      observacion: json['observacion'] as String,
    );
  }
}
