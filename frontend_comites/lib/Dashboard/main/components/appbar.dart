import 'package:comites/Auth/authScreen.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_estadisticas.dart';
import 'package:comites/constantsDesign.dart';
import 'package:comites/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.scaffoldKey,
  });

@override
Widget build(BuildContext context) {
  final usuario = context.watch<AppState>().usuarioAutenticado;

  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false, // Evita la flecha de regreso
    backgroundColor: Colors.grey[200],
    title: Text(
      title,
      style: const TextStyle(color: Colors.green),
    ),
    leading: _buildLeadingIcon(context), // Siempre muestra el ícono
    actions: [
      Row(
        children: [
          const SizedBox(width: 10), // Añade espacio extra hacia la izquierda
          if (usuario != null && usuario.nombres != null)
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'configuraciones') {
                  // Navegar a Configuraciones
                } else if (result == 'cerrar_sesion') {
                  // Acción para cerrar sesión
                  logout(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'configuraciones',
                  child: Text('Configuraciones'),
                ),
                const PopupMenuItem<String>(
                  value: 'cerrar_sesion',
                  child: Text('Cerrar Sesión'),
                ),
              ],
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    usuario.nombres!,
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(width: 8,)
                ],
              ),
            )
          else
            GestureDetector(
              onTap: () {
                // Acción para ir a la pantalla de inicio de sesión
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.login,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Iniciar Sesión",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
        ],
      ),
    ],
  );
}



  // Widget que muestra el ícono de menú en todas las pantallas
  Widget _buildLeadingIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        scaffoldKey.currentState?.openDrawer(); // Abre el SideMenu
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Espaciado alrededor de la imagen
        child: Image.asset(
          'assets/img/logo.png',
          fit: BoxFit.contain, // Ajusta cómo se muestra la imagen
          color: Colors.green,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
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
                          builder: (context) => const MainEstadisticas(solicitudes: [],)));
                }),
              )
            ],
          ),
        ],
      );
    },
  );
}

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

