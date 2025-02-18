// ignore_for_file: unnecessary_null_comparison

import 'package:comites/Auth/authScreen.dart';
import 'package:comites/Dashboard/main/Main_Funciones/Mian_verllamadotencion.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_aceptar.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_calendario.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_citarejecutor.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_estadisticas.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_llamadoatencion.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_procesos_aprendiz.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_procesos_coordinacion.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_procesos_realizados.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_radiauto.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_radicacionn.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_sena.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_subirplan.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_subirplanAprendiz.dart';
import 'package:comites/Dashboard/main/Main_Roles/main_radicacion.dart';
import 'package:comites/Dashboard/main/components/main_construccion.dart';
import 'package:comites/Dashboard/main/Main_Roles/main_abogado.dart';
import 'package:comites/Dashboard/main/Main_Roles/main_aprendiz.dart';
import 'package:comites/Dashboard/main/Main_Roles/main_bienestar.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_citacion.dart';
import 'package:comites/Dashboard/main/Main_Roles/main_coordinador.dart';
import 'package:comites/Dashboard/main/Main_Roles/main_intructor.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_solicitud.dart';
import 'package:comites/Widgets/drawerstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comites/Dashboard/controllers/MenuAppController.dart';
import 'package:comites/Home/homePage.dart';
import 'package:comites/constantsDesign.dart';
import 'package:comites/provider.dart';

/// Un widget que representa el menú lateral de la aplicación.
///
/// Este widget está diseñado para mostrar el menú lateral de la aplicación y
/// cambiar de pantalla según la opción seleccionada.
///
/// El constructor de este widget no recibe ningún parámetro.
class SideMenu extends StatefulWidget {
  /// Constructor por defecto del widget [SideMenu].
  ///
  /// No recibe ningún parámetro.
  const SideMenu({
    super.key,
  });

  /// Crea el estado asociado a este widget.
  ///
  /// Devuelve un nuevo estado [_SideMenuState].
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  /// Construye el widget del drawer basado en el estado de la aplicación.
  ///
  /// Muestra diferentes opciones de navegación dependiendo del rol y la autenticación del usuario.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;

        return Align(
            alignment: Alignment.centerLeft, // Alinea al lado izquierdo
            child: Container(
              width:
                  100, // Ajusta el ancho según el tamaño que quieras para los íconos
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(150),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // El contenedor se ajusta al tamaño de los hijos
                children: [
                  const SizedBox(height: 20),

                  // Si el usuario no está autenticado, mostramos las opciones de login y registro
                  if (appState == null || appState.usuarioAutenticado == null)
                    Column(
                      children: [
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Iniciar Sesión",
                            svgSrc:
                                "assets/icons/login.svg", // Usa el ícono de login aquí
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen(), // Pantalla de login
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "SENA",
                            svgSrc:
                                "assets/icons/logovector.svg", // Usa un ícono de registro si lo tienes
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainInfoSena(), // Pantalla de registro
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Acerca de",
                            svgSrc:
                                "assets/icons/aprendiz.svg", // Usa el ícono correspondiente para "Acerca de"
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainAprendiz(), // Pantalla "Acerca de"
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                      ],
                    ),

                  // Panel de Aprendiz
                  if (usuarioAutenticado != null &&
                      usuarioAutenticado.rol1 == "APRENDIZ")
                    Column(
                      children: [
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Panel Aprendiz",
                            svgSrc: "assets/icons/aprendiz.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainAprendiz(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Procesos",
                            svgSrc: "assets/icons/aprendiz.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainProcesosAprendiz(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Plan de Mejoramiento",
                            svgSrc: "assets/icons/abogado.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainSubirPlanAprendiz(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        )
                      ],
                    ),

                  //INICIO INSTRUCTOR

                  if (usuarioAutenticado != null &&
                      usuarioAutenticado.rol1 == "INSTRUCTOR")
                    Column(
                      children: [
                        
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Realizar Llamado de atencion",
                            svgSrc: "assets/icons/solicitud.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainLllamadoatencion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Citar a Comité Ejecutor",
                            svgSrc: "assets/icons/instructor.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainCitacionEjecutor(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Realizar Solicitud",
                            svgSrc: "assets/icons/solicitud.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainSolicitud(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Ver llamados atencion",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainVerLLamadosatencion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Procesos Realizados",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainProcesosRealizados(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Subir Plan de Mejoramiento",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainSubirPlan(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Calificar Plan de Mejoramiento",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainConstruccion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Estadisticas",
                            svgSrc: "assets/icons/estadisticas.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainEstadisticas(
                                      solicitudes: [],
                                    ),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                      ],
                    ),

                  //FINAL INSTRUCTOR

                  // INICIO ABOGADO

                  if (usuarioAutenticado != null &&
                      usuarioAutenticado.rol1 == "ABOGADO")
                    Column(
                      children: [
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Panel Abogado",
                            svgSrc: "assets/icons/abogado.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainAbogado(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Generar Actas",
                            svgSrc: "assets/icons/aprendiz.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainConstruccion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Estadisticas",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainEstadisticas(
                                      solicitudes: [],
                                    ),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                      ],
                    ),

                  //FINAL ABOGADO

                  // INICIO COORDINADOR

                  if (usuarioAutenticado != null &&
                      usuarioAutenticado.rol1 == "COORDINADOR")
                    Column(
                      children: [
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Panel Coordinador",
                            svgSrc: "assets/icons/coordinador.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainCoordinador(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Ver Procesos",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainProcesosCoordinacion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Aceptar Solicitudes",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainAceptarSolicitudes(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Agendar Comite",
                            svgSrc: "assets/icons/agendar.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainCitaciones(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Enviar Correos",
                            svgSrc: "assets/icons/bienestar.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainRadicacionesautomaticas(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Calendario",
                            svgSrc: "assets/icons/calendar.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainCalendario(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Estadisticas",
                            svgSrc: "assets/icons/estadisticas.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainEstadisticas(
                                      solicitudes: [],
                                    ),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                      ],
                    ),

                  //FINAL COORDINADOR

                  // INICIO BIENESTAR

                  if (usuarioAutenticado != null &&
                      usuarioAutenticado.rol1 == "BIENESTAR")
                    Column(
                      children: [
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Panel Bienestar",
                            svgSrc: "assets/icons/bienestar.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainBienestar(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Realizar Solicitud",
                            svgSrc: "assets/icons/aprendiz.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainSolicitud(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Ver Procesos",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainConstruccion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Subir Plan de Mejoramiento",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainConstruccion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Calificar Plan de Mejoramiento",
                            svgSrc: "assets/icons/construccion.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainConstruccion(),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),
                        Center(
                          child: ResponsiveDrawerTile(
                            title: "Estadisticas",
                            svgSrc: "assets/icons/estadisticas.svg",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController())
                                    ],
                                    child: const MainEstadisticas(
                                      solicitudes: [],
                                    ),
                                  ),
                                ),
                              );
                            },
                            iconCentered: true,
                            tooltipEnabled: true,
                          ),
                        ),

                        //FINAL BIENESTAR
                      ],
                    ),

                  if (usuarioAutenticado != null &&
                      usuarioAutenticado.rol1 == "RADICACION")
                    Column(children: [
                      Center(
                        child: ResponsiveDrawerTile(
                          title: "Panel Radicacion",
                          svgSrc: "assets/icons/bienestar.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                        create: (context) =>
                                            MenuAppController())
                                  ],
                                  child: const MainRadicacion(),
                                ),
                              ),
                            );
                          },
                          iconCentered: true,
                          tooltipEnabled: true,
                        ),
                      ),
                      Center(
                        child: ResponsiveDrawerTile(
                          title: "Radicar",
                          svgSrc: "assets/icons/bienestar.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                        create: (context) =>
                                            MenuAppController())
                                  ],
                                  child: const MainRadicacionesnumero(),
                                ),
                              ),
                            );
                          },
                          iconCentered: true,
                          tooltipEnabled: true,
                        ),
                      ),
                    ]),
                ],
              ),
            ));
      },
    );
  }
}

/// Muestra un diálogo para confirmar si el usuario desea cerrar sesión.
///
/// [context] es el contexto de la aplicación donde se mostrará el diálogo.
void logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // Título del diálogo
        title: const Text("¿Seguro que quiere cerrar sesión?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Contenedor circular con la imagen del logo de la aplicación
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                // Muestra la imagen del logo en el contenedor.
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              // Botón para cancelar la operación.
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Cancelar", () {
                  Navigator.pop(context);
                }),
              ),
              // Botón para salir de la sesión.
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Salir", () {
                  Navigator.pop(context);
                  Provider.of<AppState>(context, listen: false).logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                }),
              )
            ],
          ),
        ],
      );
    },
  );
}

/// Construye un botón con los estilos de diseño especificados.
///
/// El parámetro [text] es el texto que se mostrará en el botón.
/// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
///
/// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
Widget _buildButton(String text, VoidCallback onPressed) {
  // Contenedor con un ancho fijo de 200 píxeles y una apariencia personalizada
  // con un borde redondeado, un gradiente de colores y una sombra.
  return Container(
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Borde redondeado.
      gradient: const LinearGradient(
        colors: [
          botonClaro, // Color claro del gradiente.
          botonOscuro, // Color oscuro del gradiente.
        ],
      ),
      boxShadow: const [
        BoxShadow(
          color: botonSombra, // Color de la sombra.
          blurRadius: 5, // Radio de desfoque de la sombra.
          offset: Offset(0, 3), // Desplazamiento de la sombra.
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent, // Color transparente para el Material.
      child: InkWell(
        onTap: onPressed, // Función de presionar.
        borderRadius: BorderRadius.circular(10), // Radio del borde redondeado.
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 10), // Padding vertical.
          child: Center(
            child: Text(
              text, // Texto del botón.
              style: const TextStyle(
                color: background1, // Color del texto.
                fontSize: 13, // Tamaño de fuente.
                fontWeight: FontWeight.bold, // Peso de fuente.
                fontFamily: 'Calibri-Bold', // Fuente.
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
