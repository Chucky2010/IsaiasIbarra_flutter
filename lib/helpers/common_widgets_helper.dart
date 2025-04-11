import 'package:flutter/material.dart';

class CommonWidgetsHelper {


  // Método: titulo en negrita
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Método: lineas de informacion
  static Widget buildInfoLines({
    required String firstLine,
    String? secondLine,
    String? thirdLine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(firstLine, style: const TextStyle(fontSize: 16)),
        if (secondLine != null)
          Text(secondLine, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        if (thirdLine != null)
          Text(thirdLine, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Método: pie de pagina en negrita
  static Widget buildBoldFooter(String footerText) {
    return Text(
      footerText,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  // Método: espaciado
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  // Método: borde redondeado
  static ShapeBorder buildRoundedBorder() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
  }
}