// ignore_for_file: file_names, unnecessary_null_comparison

/*
 Motivo de la creacion: Mostrar el splash de la aplicacion en diferentes secciones con
 informacion diferente en cada una.
 Nombre de la persona que lo creó: William David Garzon 
*/

import 'dart:async';
import 'package:comites/Dashboard/main/Main_Funciones/main_estadisticas.dart';
import 'package:comites/constantsDesign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/list.dart';

// Clase SplashScreen, que representa la pantalla de presentación.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Estado asociado a SplashScreen.
class _SplashScreenState extends State<SplashScreen> {
  PageController? controller; // Controlador de la página.
  int currentIndex = 0; // Índice actual.
  double porcentaje = 0.20; // Porcentaje inicial.
  int currentImageIndex = 0; // Indice de imagenes
  List<int> currentImageIndexes = [];
  Timer? _imageTimer;
  Timer? _pageChangeTimer;

  late bool colors = true; // Variable para controlar colores.

  @override
  void initState() {
    // Inicialización del controlador de la página.
    controller = PageController(initialPage: 0);
    currentImageIndex = 0;
    super.initState();
    _startImageTimer();
    _startPageChangeTimer();
  }

  void _startPageChangeTimer() {
    _imageTimer = Timer.periodic(const Duration(seconds: 12), (Timer timer) {
      if (mounted) {  // Verifica si el widget está montado antes de realizar la navegación
        if (currentIndex < listaComponents.length - 1) {
          controller!.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else if (currentIndex == listaComponents.length - 1) {
          timer.cancel();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MainEstadisticas(solicitudes: [],)),
          );
        }
      }
    });
  }

  void _startImageTimer() {
    _pageChangeTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (mounted) {  // Verifica si el widget está montado antes de llamar a setState()
        setState(() {
          if (currentImageIndex < 2) {
            currentImageIndex += 1;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // Liberación de recursos del controlador al destruir el estado.
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construcción de la interfaz de usuario usando Scaffold.
    return Scaffold(
        backgroundColor: listaComponents[currentIndex].background,
        body: LayoutBuilder(
          builder: (context, responsive) {
            if (responsive.maxWidth <= 300) {
              // Estructura de la interfaz para pantallas con ancho menor o igual a 300.
              return Stack(
                children: [
                  // Comprobación y representación condicional del fondo.
                  if (listaComponents[currentIndex].backgroundColor != null)
                    listaComponents[currentIndex].backgroundColor!,
                  Row(
                    children: [
                      // Contenido principal.
                      Expanded(
                          flex: 5,
                          child: PageView.builder(
                              controller: controller,
                              itemCount: listaComponents.length,
                              onPageChanged: (int index) {
                                if (index >= currentIndex) {
                                  setState(() {
                                    currentImageIndex = 0;
                                    currentIndex = index;
                                    porcentaje += 0.20;
                                  });
                                } else {
                                  setState(() {
                                    currentImageIndex = 0;
                                    currentIndex = index;
                                    porcentaje -= 0.20;
                                  });
                                }
                                _imageTimer?.cancel();
                                _pageChangeTimer?.cancel();
                                _startImageTimer();
                                _startPageChangeTimer();
                              },
                              itemBuilder: (context, index) {
                                
                                // Construcción del contenido de cada página.
                                if (listaComponents[currentIndex].background ==
                                    Colors.white) {
                                  colors = true;
                                } else {
                                  colors = false;
                                }
                                if (listaComponents[index].background ==
                                    Colors.white) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          listaComponents[index].titulo,
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              fontFamily: "Calibri"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            listaComponents[index].descripcion,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              //fontFamily: "DelaGothicOne"
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 60),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          listaComponents[index].titulo,
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              fontFamily: "Calibri"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            listaComponents[index].descripcion,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              //fontFamily: "DelaGothicOne"
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              })),
                    ],
                  ),
                  // Barra de navegación y botones de acción.
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Indicadores de página.
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: List.generate(
                                          listaComponents.length,
                                          (index) => buildDot(index, context)),
                                    ),
                                  ),
                                  // Botón "Omitir".
                                  CupertinoButton(
                                      child: Container(
                                          width: 100,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: listaComponents[currentIndex]
                                                        .background ==
                                                    Colors.white
                                                ? primaryColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Omitir",
                                              style: TextStyle(
                                                  color: listaComponents[
                                                                  currentIndex]
                                                              .background ==
                                                          Colors.white
                                                      ? Colors.white
                                                      : primaryColor,
                                                  fontFamily: 'Calibri-Bold',
                                                  fontSize: 17),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainEstadisticas(solicitudes: [],),
                                          ),
                                          (route) => false,
                                        );
                                      })
                                ],
                              ),
                              // Botón de avance y porcentaje de carga.
                              CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 55,
                                        width: 55,
                                        child: CircularProgressIndicator(
                                          value: porcentaje,
                                          backgroundColor: colors
                                              ? Colors.grey
                                              : Colors.grey,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  listaComponents[currentIndex]
                                                              .background ==
                                                          Colors.white
                                                      ? primaryColor
                                                      : Colors.white),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            listaComponents[currentIndex]
                                                        .background ==
                                                    Colors.white
                                                ? primaryColor
                                                : Colors.white,
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: listaComponents[currentIndex]
                                              .background,
                                        ),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    if (currentIndex ==
                                        listaComponents.length - 1) {
                                      if (porcentaje == 1) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainEstadisticas(solicitudes: [],)),
                                          (route) => false,
                                        );
                                      }
                                    }
                                    controller!.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  })
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else if (responsive.maxWidth >= 1000) {
              // Estructura de la interfaz para pantallas con ancho mayor o igual a 1000.
              return Stack(
                children: [
                  // Comprobación y representación condicional del fondo.
                  if (listaComponents[currentIndex].backgroundColor != null)
                    listaComponents[currentIndex].backgroundColor!,
                  // Contenido principal.
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: PageView.builder(
                              controller: controller,
                              itemCount: listaComponents.length,
                              onPageChanged: (int index) {
                                if (index >= currentIndex) {
                                  setState(() {
                                    currentImageIndex = 0;
                                    currentIndex = index;
                                    porcentaje += 0.20;
                                  });
                                } else {
                                  setState(() {
                                    currentImageIndex = 0;
                                    currentIndex = index;
                                    porcentaje -= 0.20;
                                  });
                                }
                                _imageTimer?.cancel();
                                _pageChangeTimer?.cancel();
                                _startImageTimer();
                                _startPageChangeTimer();
                              },
                              itemBuilder: (context, index) {
                                
                                // Construcción del contenido de cada página.
                                if (listaComponents[currentIndex].background ==
                                    Colors.white) {
                                  colors = true;
                                } else {
                                  colors = false;
                                }
                                if (listaComponents[index].background ==
                                    Colors.white) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Stack(
                                              children: [
                                                  AnimatedSwitcher(
                                                  duration: const Duration(seconds: 1),
                                                  child: ClipRRect(
                                                    key: ValueKey<int>(currentImageIndex),
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: Image.asset(
                                                      listaComponents[index].imagen2[currentImageIndex],
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    color: Colors.black.withOpacity(0.2),
                                                  ),
                                                ),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      listaComponents[index].titulo,
                                                      style: const TextStyle(
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        fontFamily: "Calibri",
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 5,
                                          child: Stack(children: [
                                            // Comprobación y representación condicional del fondo.
                                            if (listaComponents[currentIndex]
                                                    .backgroundColor !=
                                                null)
                                              listaComponents[currentIndex]
                                                  .backgroundColor!,
                                            Center(
                                              child: Text(
                                                listaComponents[index]
                                                    .descripcion,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: colors
                                                      ? primaryColor
                                                      : Colors.white,
                                                  //fontFamily: "DelaGothicOne"
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ]))
                                    ],
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(height: 30),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          listaComponents[index].descripcion,
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: colors
                                                ? primaryColor
                                                : Colors.white,
                                            //fontFamily: "DelaGothicOne"
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            AnimatedSwitcher(
                                              duration: const Duration(seconds: 1),
                                              child: ClipRRect(
                                                key: ValueKey<int>(currentImageIndex),
                                                borderRadius: BorderRadius.circular(20),
                                                child: Image.asset(
                                                  listaComponents[index].imagen2[currentImageIndex],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: MediaQuery.of(context).size.height,
                                              decoration: BoxDecoration(
                                                color: const Color(0x27000000), // Semi-transparente para overlay
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  listaComponents[index].titulo,
                                                  style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily: "Calibri",
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )]
                                  );
                                }
                              })),
                    ],
                  ),
                  // Barra de navegación y botones de acción.
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Indicadores de página.
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: List.generate(
                                          listaComponents.length,
                                          (index) => buildDot(index, context)),
                                    ),
                                  ),
                                  // Botón "Omitir".
                                  CupertinoButton(
                                      child: Container(
                                          width: 120,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: listaComponents[currentIndex]
                                                        .background ==
                                                    Colors.white
                                                ? primaryColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Omitir",
                                              style: TextStyle(
                                                  color: listaComponents[
                                                                  currentIndex]
                                                              .background ==
                                                          Colors.white
                                                      ? Colors.white
                                                      : primaryColor,
                                                  fontFamily: 'Calibri-Bold',
                                                  fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainEstadisticas(solicitudes: [],),
                                          ),
                                          (route) => false,
                                        );
                                      })
                                ],
                              ),
                              // Botón de avance y porcentaje de carga.
                              CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 55,
                                        width: 55,
                                        child: CircularProgressIndicator(
                                          value: porcentaje,
                                          backgroundColor: colors
                                              ? Colors.grey
                                              : Colors.grey,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  listaComponents[currentIndex]
                                                              .background ==
                                                          Colors.white
                                                      ? primaryColor
                                                      : Colors.white),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            listaComponents[currentIndex]
                                                        .background ==
                                                    Colors.white
                                                ? primaryColor
                                                : Colors.white,
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: listaComponents[currentIndex]
                                              .background,
                                        ),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    if (currentIndex ==
                                        listaComponents.length - 1) {
                                      if (porcentaje == 1) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainEstadisticas(solicitudes: [],),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    }
                                    controller!.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  })
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else {
              // Estructura de la interfaz para pantallas con ancho entre 300 y 1000.
              return Stack(
                children: [
                  // Comprobación y representación condicional del fondo.
                  if (listaComponents[currentIndex].backgroundColor != null)
                    listaComponents[currentIndex].backgroundColor!,
                  // Contenido principal.
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: PageView.builder(
                              controller: controller,
                              itemCount: listaComponents.length,
                              onPageChanged: (int index) {
                                if (index >= currentIndex) {
                                  setState(() {
                                    currentImageIndex = 0;
                                    currentIndex = index;
                                    porcentaje += 0.20;
                                  });
                                } else {
                                  setState(() {
                                    currentImageIndex = 0;
                                    currentIndex = index;
                                    porcentaje -= 0.20;
                                  });
                                }
                                _imageTimer?.cancel();
                                _pageChangeTimer?.cancel();
                                _startImageTimer();
                                _startPageChangeTimer();
                              },
                              itemBuilder: (context, index) {
                                
                                // Construcción del contenido de cada página.
                                if (listaComponents[currentIndex].background ==
                                    Colors.white) {
                                  colors = true;
                                } else {
                                  colors = false;
                                }
                                if (listaComponents[index].background ==
                                    Colors.white) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          listaComponents[index].titulo,
                                          style: TextStyle(
                                              fontSize: 37,
                                              fontWeight: FontWeight.bold,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              fontFamily: "Calibri"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            listaComponents[index].descripcion,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              //fontFamily: "DelaGothicOne"
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 60),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          listaComponents[index].titulo,
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              fontFamily: "Calibri"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            listaComponents[index].descripcion,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: colors
                                                  ? primaryColor
                                                  : Colors.white,
                                              //fontFamily: "DelaGothicOne"
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              })),
                    ],
                  ),
                  // Barra de navegación y botones de acción.
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Indicadores de página.
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: List.generate(
                                          listaComponents.length,
                                          (index) => buildDot(index, context)),
                                    ),
                                  ),
                                  // Botón "Omitir".
                                  CupertinoButton(
                                      child: Container(
                                          width: 120,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: listaComponents[currentIndex]
                                                        .background ==
                                                    Colors.white
                                                ? primaryColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Omitir",
                                              style: TextStyle(
                                                  color: listaComponents[
                                                          currentIndex]
                                                      .background,
                                                  fontFamily: 'Calibri-Bold',
                                                  fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainEstadisticas(solicitudes: [],),
                                          ),
                                          (route) => false,
                                        );
                                      })
                                ],
                              ),
                              // Botón de avance y porcentaje de carga.
                              CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 55,
                                        width: 55,
                                        child: CircularProgressIndicator(
                                          value: porcentaje,
                                          backgroundColor: colors
                                              ? Colors.grey
                                              : Colors.grey,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            listaComponents[currentIndex]
                                                        .background ==
                                                    Colors.white
                                                ? primaryColor
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            listaComponents[currentIndex]
                                                        .background ==
                                                    Colors.white
                                                ? primaryColor
                                                : Colors.white,
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: listaComponents[currentIndex]
                                              .background,
                                        ),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    if (currentIndex ==
                                        listaComponents.length - 1) {
                                      if (porcentaje == 1) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainEstadisticas(solicitudes: [],),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    }
                                    controller!.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  })
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
          },
        ));
  }

  // Función para construir y animar un contenedor que representa un indicador de punto en la interfaz.
  // ignore: non_constant_identifier_names
  AnimatedContainer buildDot(int Index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500), // Duración de la animación.
      curve:
          Curves.easeInOut, // Curva de la animación para suavizar los cambios.
      height: 8, // Altura del contenedor.
      width: currentIndex == Index
          ? 24
          : 8, // Ancho del contenedor dependiendo del índice actual.
      margin: const EdgeInsets.only(
          right: 5), // Margen derecho para separar los puntos.
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20), // Bordes redondeados del contenedor.
          color: currentIndex == Index
              ? Colors.grey
              : Colors
                  .grey // Color del contenedor, gris para seleccionado o no seleccionado.
          ),
    );
  }
}
