// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResponsiveDrawerTile extends StatelessWidget {
  final String title;
  final String? svgSrc;
  final String? imageSrc; // Nuevo parámetro para aceptar imágenes
  final VoidCallback press;
  final bool iconCentered;
  final bool tooltipEnabled;

  const ResponsiveDrawerTile({
    super.key,
    required this.title,
    this.svgSrc,
    this.imageSrc,
    required this.press,
    this.iconCentered = false,
    this.tooltipEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determina el tamaño de la pantalla
    double width = MediaQuery.of(context).size.width;

    // Consideramos móviles: menos de 600px
    bool isMobile = width < 600;

    // Consideramos tabletas: entre 600px y 1024px
    bool isTablet = width >= 600 && width < 1024;

    if (isMobile || isTablet) {
      // Usa la clase `DrawerListTile` para móvil o tablet
      return DrawerListTile(
        title: title,
        svgSrc: svgSrc,
        imageSrc: imageSrc,
        press: press,
      );
    } else {
      // Usa la clase `DrawerNew` para pantallas más grandes (desktop)
      return DrawerNew(
        title: title,
        svgSrc: svgSrc,
        imageSrc: imageSrc,
        press: press,
        iconCentered: iconCentered,
        tooltipEnabled: tooltipEnabled,
      );
    }
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final String? svgSrc;
  final String? imageSrc; // Nuevo parámetro para aceptar imágenes
  final VoidCallback press;

  const DrawerListTile({
    super.key,
    required this.title,
    this.svgSrc,
    this.imageSrc,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 10.0,
      leading: SizedBox(
        height: 24,
        width: 24,
        child: imageSrc != null
            ? Image.asset(
                imageSrc!,
                fit: BoxFit.cover,
              )
            : SvgPicture.asset(
                svgSrc!,
                colorFilter: const ColorFilter.mode(
                  Colors.green, // Cambia el color según tu necesidad
                  BlendMode.srcIn,
                ),
              ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.green,
          fontFamily: 'Calibri-Bold',
        ),
      ),
    );
  }
}

class DrawerNew extends StatelessWidget {
  final String title;
  final String? svgSrc;
  final String? imageSrc; // Nuevo parámetro para aceptar imágenes
  final VoidCallback press;
  final bool iconCentered;
  final bool tooltipEnabled;

  const DrawerNew({
    super.key,
    required this.title,
    this.svgSrc,
    this.imageSrc,
    required this.press,
    this.iconCentered = false,
    this.tooltipEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
        crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
        children: [
          tooltipEnabled
              ? Tooltip(
                  message: title,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  child: imageSrc != null
                      ? Image.asset(
                          imageSrc!,
                          height: 30, // Ajusta el tamaño según sea necesario
                          width: 30,
                          fit: BoxFit.cover,
                        )
                      : SvgPicture.asset(
                          svgSrc!,
                          height: 30,
                          width: 30,
                          color: Colors.green,
                        ),
                )
              : (imageSrc != null
                  ? Image.asset(
                      imageSrc!,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    )
                  : SvgPicture.asset(
                      svgSrc!,
                      height: 48,
                      width: 48,
                    )),
          const SizedBox(height: 10), // Espaciado entre el ícono y el texto
          if (!iconCentered)
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
