import 'package:flutter/material.dart';
import 'package:mi_proyecto/helpers/dialog_helper.dart';
import 'package:mi_proyecto/views/contador_screen.dart';
import 'package:mi_proyecto/views/mi_app_screen.dart';
import 'package:mi_proyecto/views/noticia_screen.dart';
import 'package:mi_proyecto/views/quote_screen.dart';
import 'package:mi_proyecto/views/start_screen.dart';
import 'package:mi_proyecto/views/welcome_screen.dart';
import 'package:mi_proyecto/views/tarea_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tema actual
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor, // Usar el color de fondo del tema
      elevation: 4.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary, // Usar el color primario del tema
            ),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menú',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary, // Usar color para texto sobre fondo primario
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.home,
            title: 'Inicio',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.bar_chart,
            title: 'Cotizaciones',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.task,
            title: 'Tareas',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TareaScreen()),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.newspaper,
            title: 'Noticias',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NoticiaScreen()),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.apps,
            title: 'Mi App',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MiAppScreen()),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.numbers,
            title: 'Contador',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContadorScreen(title: 'Contador'),
                ),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.stars,
            title: 'Juego',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartScreen(),
                ),
              );
            },
          ),
          const Divider(), // Separador antes de la opción de cerrar sesión
          _buildMenuItem(
            context: context,
            icon: Icons.exit_to_app,
            title: 'Cerrar Sesión',
            onTap: () {
              DialogHelper.mostrarDialogoCerrarSesion(context);
            },
            isLogout: true,
          ),
        ],
      ),
    );
  }
  
  // Método auxiliar para crear elementos del menú con estilo consistente
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Usar color de acento para la opción de cerrar sesión
    final Color iconColor = isLogout 
        ? colorScheme.error  // Usar color de error para cerrar sesión
        : colorScheme.primary; // Usar color primario para las demás opciones
    
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isLogout ? colorScheme.error : colorScheme.onSurface,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      tileColor: Colors.transparent,
      hoverColor: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0,
      ),
    );
  }
}