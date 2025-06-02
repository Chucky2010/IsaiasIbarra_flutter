import 'package:flutter/material.dart';

class AppColors {
  // Colores principales de la marca
  static const Color primaryDarkBlue = Color(0xFF10498A); // Azul oscuro - Color principal de la marca
  static const Color primaryLightBlue = Color(0xFF006CB5); // Azul claro - Variación de la marca para elementos secundarios
  static const Color neutralGray = Color(0xFF898989); // Gris - Para textos secundarios y elementos neutrales

  // Definición de roles de colores para la interfaz
  static const Color primary = primaryDarkBlue;      // Usado en: botones principales, barra de navegación, elementos destacados
  static const Color primaryHover = primaryLightBlue; // Usado en: estado hover de botones, enlaces al pasar el cursor
  static const Color primaryActive = neutralGray;     // Usado en: estado presionado de botones, elementos seleccionados
  static const Color surface = gray02;               // Usado en: fondos de tarjetas, diálogos, áreas de contenido
  static const Color background =white; // Usado en: fondo general de la aplicación
  static const Color disabled = gray07; // Para elementos UI desactivados

  // Gray Scale
  static const Color gray01 = Color(0xFFFFFFFF); //Blanco puro
  static const Color gray02 = Color(0xFFF7F7F7);
  // Agregando grays faltantes
  static const Color gray03 = Color(0xFFEFEFEF);
  static const Color gray04 = Color(0xFFE6E6E6);
  static const Color gray05 = Color(0xFFDDDDDD);
  static const Color gray06 = Color(0xFFD4D4D4);
  static const Color gray07 = Color(0xFFCCCCCC);
  static const Color gray08 = Color(0xFFB5B5B5);
  // Agregando grays intermedios faltantes
  static const Color gray09 = Color(0xFF999999);
  static const Color gray10 = Color(0xFF808080);
  static const Color gray11 = Color(0xFF666666);
  static const Color gray12 = Color(0xFF4D4D4D);
  static const Color gray13 = Color(0xFF353535);
  static const Color gray14 = Color(0xFF303030);
  static const Color gray15 = Color(0xFF282828);
  static const Color gray16 = Color(0xFF1A1A1A);

  // Colores adicionales
  static const Color blue01 = Color(0xFFF2F6FF);
  static const Color blue02 = Color(0xFFE6EEFE);
  static const Color blue03 = Color(0xFFCDDDFC);
  static const Color blue04 = Color(0xFFB4CCFB);
  static const Color blue09 = Color(0xFF3776F5);
  static const Color blue10 = Color(0xFF1E65F3);
  static const Color blue11 = Color(0xFF0554F2);
  static const Color blue12 = Color(0xFF0443C2);
  static const Color blue13 = Color(0xFF033291);
  static const Color blue14 = Color(0xFF022261);
  static const Color blue15 = Color(0xFF01153D);
  static const Color blue16 = Color(0xFF011130);
  static const Color blue17 = Color(0xFF002D72);

  // Colores para estados y errores
  static const Color error = Color(0xFFE53935);       // Rojo para errores críticos y validación fallida
  static const Color info = Color(0xFF0277BD);        // Azul que complementa primaryDarkBlue para información
  static const Color success = Color(0xFF2E7D32);     // Verde para acciones exitosas y confirmaciones
  static const Color warning = Color(0xFFF9A825);     // Amarillo/naranja para advertencias e información importante
  static const Color notFound = gray10;               // Gris medio para recursos no encontrados (404)
  static const Color unknownError = blue13;           // Azul oscuro para errores desconocidos o no categorizados
  
  // Colores para estados específicos HTTP
  static const Color serverError = Color(0xFFB71C1C); // Rojo oscuro para errores de servidor (500, 503)
  static const Color rateLimit = Color(0xFFFFB300);   // Amarillo ámbar para límites de tasa alcanzados (429)
  static const Color networkError = Color(0xFF3949AB); // Azul índigo para errores de red y conexión
  
  static const Color white = Color(0xFFFFFFFF);

}
