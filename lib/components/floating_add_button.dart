import 'package:flutter/material.dart';

/// Botón flotante para acciones de creación
class FloatingAddButton extends StatelessWidget {
  /// Función que se ejecutará al presionar el botón
  final VoidCallback onPressed;
  
  /// Texto para el tooltip (descripción al mantener pulsado)
  final String tooltip;
  
  /// Color de fondo del botón, por defecto usa el color primario del tema
  final Color? backgroundColor;
  
  /// Icono del botón, por defecto es un icono de añadir (Icons.add)
  final IconData icon;
  
  /// Posición del botón
  final FloatingActionButtonLocation? location;

  const FloatingAddButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Agregar',
    this.backgroundColor,
    this.icon = Icons.add,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      child: Icon(icon),
    );
  }
}