import 'package:flutter/material.dart';

class CommentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool ordenAscendente;
  final Function(bool) onOrdenChanged;
  final String? titulo;

  const CommentAppBar({
    super.key,
    required this.ordenAscendente,
    required this.onOrdenChanged,
    this.titulo,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo != null ? 'Comentarios: $titulo' : 'Comentarios'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Tooltip(
          message: ordenAscendente 
              ? 'Ordenar por más recientes' 
              : 'Ordenar por más antiguos',
          child: IconButton(
            onPressed: () => onOrdenChanged(!ordenAscendente),
            icon: Icon(ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward),
          ),
        ),
      ],
    );
  }
}