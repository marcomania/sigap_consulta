import 'package:flutter/material.dart';
import 'package:fisi_army/models/recaudacionesAlumno.dart';
import 'package:fisi_army/utilities/constants.dart';

class DetallePage extends StatelessWidget {
  final RecaudacionesAlumno recaudacion;

  const DetallePage({Key key, this.recaudacion}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*Center(
                    child: Hero(
                        tag: '${product.idRec}',
                        child: Material(
                          child: ProductPoster(
                            size: size,
                            image:
                                'https://github.com/flutter/plugins/raw/master/packages/video_player/video_player/doc/demo_ipod.gif?raw=true',
                          ),
                        )),
                  ),*/
                  //ListOfColors(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2),
                    child: Text(
                      recaudacion.nomPrograma,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(
                    '\$${recaudacion.importe}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: kSecondaryColor,
                    ),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                    child: Text(
                      recaudacion.descripcionTipo,
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ),
                  Hero(
                    tag: 'fecha' + '${recaudacion.idRec}',
                    child: Material(
                      child: InkWell(
                        child: Text(
                          "${recaudacion.fecha}",
                          textAlign: TextAlign.right,
                          //style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 200),
                ],
              ),
            ),
            //ChatAndAddToCart(),
          ],
        ),
      ),
    );
  }
}
