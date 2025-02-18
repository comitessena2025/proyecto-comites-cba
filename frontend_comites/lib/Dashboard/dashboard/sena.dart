// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, unused_field

import 'package:comites/constantsDesign.dart';
import 'package:comites/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoSena extends StatefulWidget {
  const InfoSena({super.key});

  @override
  _InfoSenaState createState() => _InfoSenaState();
}

class _InfoSenaState extends State<InfoSena> {

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _quienesSomosKey = GlobalKey();

  final List<GlobalKey> _sectionKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  void _scrollToSection(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
        actions: [
          Tooltip(
            message: '¿Quiénes somos?',
            child: IconButton(
            icon: const Icon(Icons.question_mark, color: primaryColor, size: 28),
              onPressed: () {_scrollToSection(0);
              },
            ),
          ),
          Tooltip(
            message: 'Misión y Visión',
            child: IconButton(
            icon: const Icon(Icons.star, color: primaryColor, size: 28),
              onPressed: () {_scrollToSection(1);
              },
            ),
          ),
          Tooltip(
            message: 'Escudo y Bandera',
            child: IconButton(
            icon: const Icon(Icons.work, color: primaryColor, size: 28),
              onPressed: () {_scrollToSection(2);
              },
            ),
          ),
          Tooltip(
            message: 'Logo Sena',
            child: IconButton(
            icon: SvgPicture.asset("assets/icons/logovector.svg", color: primaryColor, width: 28, height: 28),
              onPressed: () {_scrollToSection(3);
              },
            ),
          ),
          Tooltip(
            message: 'Contactos',
            child: IconButton(
            icon: const Icon(Icons.phone, color: primaryColor, size: 28),
              onPressed: () {_scrollToSection(4);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
            child: Column(
              children: [
                Align(
                  key: _sectionKeys[0],
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "¿Quiénes somos?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: Responsive.isMobile(context)
                  ? const EdgeInsets.only(top: 20, left: 20, right: 20)
                  : const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 30),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'El Sena es un establecimiento público nacional con autonomía administrativa, adscrito al Ministerio del Trabajo. Cuenta con personería jurídica, patrimonio propio, y ofrece formación gratuita en programas técnicos, tecnológicos y complementarios para el desarrollo económico y social del país. Autorizado por el Estado, invierte en infraestructura para mejorar el desarrollo social y técnico de los trabajadores en diferentes regiones.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: !Responsive.isMobile(context)
                        ? const Text(
                          'La entidad funciona en alianza con el Gobierno, empresarios y trabajadores para aumentar la capacidad de progreso en Colombia, promoviendo la inclusión social y la creación de empleo. Impulsa programas de responsabilidad social, formación, innovación y transferencia de conocimientos y tecnologías para aumentar la productividad y competitividad de las empresas colombianas.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                        )
                        : const Text("")
                      ),
                    ],
                  ),
                ),
                Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 150, // Espacio entre las imágenes
                    runSpacing: 30, // Espacio entre las filas
                    children: [
                      Container(
                        width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.7
                        : MediaQuery.of(context).size.width * 0.25,
                        height: Responsive.isMobile(context) 
                        ? MediaQuery.of(context).size.width * 0.7
                        : MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/img/Sena1.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.7
                        : MediaQuery.of(context).size.width * 0.25,
                        height: Responsive.isMobile(context) 
                        ? MediaQuery.of(context).size.width * 0.7
                        : MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/img/Sena2.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 40,
              ),
              Align(
                key: _sectionKeys[1],
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Misión y Visión",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: Responsive.isMobile(context)
                    ? const EdgeInsets.only(top: 20, left: 20, right: 20)
                    : const EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Responsive.isMobile(context)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Misión',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "El Sena está encargado de cumplir la función que le corresponde al Estado de invertir en el desarrollo social y técnico de los trabajadores colombianos, ofreciendo y ejecutando la formación profesional integral, para la incorporación y el desarrollo de las personas en actividades productivas que contribuyan al desarrollo social, económico y tecnológico del país (Ley 119/1994)",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 31, 31, 31),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/img/Sena3.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/img/Sena3.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Misión',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  "El Sena está encargado de cumplir la función que le corresponde al Estado de invertir en el desarrollo social y técnico de los trabajadores colombianos, ofreciendo y ejecutando la formación profesional integral, para la incorporación y el desarrollo de las personas en actividades productivas que contribuyan al desarrollo social, económico y tecnológico del país (Ley 119/1994).",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 31, 31, 31),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: Responsive.isMobile(context)
                    ? const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30)
                    : const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 30),
                child: Responsive.isMobile(context)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Visión',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Para el año 2026, el Servicio Nacional de Aprendizaje - Sena estará a la vanguardia de la cualificación del talento humano, tanto a nivel nacional como internacional. Esto se logrará a través de la formación profesional integral, el empleo, el emprendimiento y el reconocimiento de aprendizajes previos.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 31, 31, 31),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/img/Sena4.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Visión',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Para el año 2026, el Servicio Nacional de Aprendizaje - Sena estará a la vanguardia de la cualificación del talento humano, tanto a nivel nacional como internacional. Esto se logrará a través de la formación profesional integral, el empleo, el emprendimiento y el reconocimiento de aprendizajes previos.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 31, 31, 31),
                                  ),
                                ),
                                Text(
                                  "Nuestro objetivo es generar valor público y fortalecer la economía campesina, popular, verde y digital, siempre con un enfoque diferencial orientado a la construcción del cambio, la transformación productiva, la soberanía alimentaria y la consolidación de una paz total, materializando así la autonomía territorial, y promoviendo la justicia social, ambiental y económica",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 31, 31, 31),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/img/Sena4.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), 
              const SizedBox(height: 10),
              Align(
                key: _sectionKeys[2],
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Escudo y Bandera",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.only(top: 20, left: 20, right: 20)
            : const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Responsive.isMobile(context) ? Alignment.center : Alignment.centerLeft,
              child: const Text(
                "El Sena tiene sus propios elementos institucionales, que son los símbolos y el reflejo de sus valores y principios. La bandera es uno de estos elementos, y también tiene un escudo. La bandera nacional refleja los valores y principios que conforman el Sena.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Responsive.isMobile(context) ? Alignment.center : Alignment.centerLeft,
              child: const Text(
                'Escudo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ),
            Align(
              alignment: Responsive.isMobile(context) ? Alignment.center : Alignment.centerLeft,
              child: const Text(
                "Reflejan los tres sectores económicos dentro de los cuales se ubica el accionar de la institución, a saber: el piñón, el caduceo, y el café.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
              ),
            ),
            const SizedBox(height: 20),
            !Responsive.isMobile(context)
                ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "img/escudo.jpg",
                            width:MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 20),
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'El Engranaje', 
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                            Text(
                              "Representativo del sector industria.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                            ),
                            SizedBox(height: 10), // Espacio entre las líneas de texto
                            Text(
                              'El caduceo', 
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                            Text(
                              "Asociado al de comercio y servicios.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                            ),
                            SizedBox(height: 10), // Espacio entre las líneas de texto
                            Text(
                              'Rama de Café', 
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                            Text(
                              "Ligado al primario y extractivo.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                            ),
                          ],
                        ),
                      
                    ],
                  ),
                )
                  : Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "img/escudo.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'El Engranaje',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Representativo del sector industria.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'El caduceo',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Asociado al de comercio y servicios.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Rama de Café',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Ligado al primario y extractivo.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              Align(
                alignment: Responsive.isMobile(context) ? Alignment.center : Alignment.centerLeft,
                child: const Text(
                  'Bandera',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "La bandera de Sena está representada por el escudo del Sena. La bandera fue diseñada cuando la institución comenzó a funcionar. La bandera del Sena es blanca con el escudo en el centro. El blanco representa la paz y la tranquilidad. Es rectangular y con el logo en el centro, se utiliza en todos los eventos y celebraciones institucionales.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.width * 0.25,
                  height: Responsive.isMobile(context) 
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "img/bandera.jpg",
                        fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),   
            Align(
                key: _sectionKeys[3],
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Logo Sena",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: Responsive.isMobile(context)
                  ? const EdgeInsets.only(top: 20, left: 20, right: 20)
                  : const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ! Responsive.isMobile(context)
                          ? const Text('Una de las figuras y símbolos más reconocibles del Sena es su logotipo, que acompaña a cada aprendiz, instructor, actividad y proceso del Servicio Nacional de Aprendizaje.',
                            textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                        )
                      : const SizedBox(width:0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                        child: Text('El logo símbolo del Sena representa al hombre en un camino hacia el horizonte. Pretende ser un elemento motivador incorporando conceptos fundamentalmente filosóficos sobre la formación profesional para hacer partícipes a funcionarios,  aprendices, instructores y al medio social en su conjunto; la búsqueda permanente de nuevos horizontes, de nuevos caminos, enfocándolos hacia el futuro con creatividad e iniciativa.',
                          textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 31, 31, 31)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: !Responsive.isMobile(context)
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox( 
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: ClipRRect(
                            child: Image.asset(
                              "img/logo2.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Estilo negro",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 31, 31, 31),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.3,
                            child: const Text(
                              "El logo negro del Sena representa la Elegancia, la sotisficación, la Seriedad y la Disciplina.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 31, 31, 31),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 60),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: ClipRRect(
                            child: SvgPicture.asset(
                              "/icons/logovector.svg",
                              color: primaryColor,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Estilo verde",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.3,
                            child: const Text(
                              "El logo verde del Sena representa la Productividad, la Estabilidad, el Desarrollo y la Verdad.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox( 
                          width: MediaQuery.of(context).size.width * 0.7,
                          height:  MediaQuery.of(context).size.width * 0.7,
                          child: ClipRRect(
                            child: Image.asset(
                              "img/logo2.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Estilo negro",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 31, 31, 31),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.7,
                            child: const Text(
                              "El logo negro del Sena representa la Elegancia, la sotisficación, la Seriedad y la Disciplina.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 31, 31, 31),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 60),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: ClipRRect(
                            child: SvgPicture.asset(
                              "/icons/logovector.svg",
                              color: primaryColor,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Estilo verde",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.7,
                            child: const Text(
                              "El logo verde del Sena representa la Productividad, la Estabilidad, el Desarrollo y la Verdad.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )
            ]
          )
        )
      )
    );
  }
}
