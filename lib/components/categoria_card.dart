import 'package:flutter/material.dart';
import 'package:mi_proyecto/domain/categoria.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onEdit;

  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Tooltip(
        message: 'Editar categoría',
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              categoria.imagenUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  child: Icon(
                    Icons.broken_image,
                    color: isDark ? Colors.grey[600] : Colors.grey,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60,
                  height: 60,
                  color: isDark ? Colors.grey[700] : Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
          title: Text(
            categoria.nombre,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          subtitle: Text(
            categoria.descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit, 
                  color: theme.colorScheme.primary,
                ),
                onPressed: onEdit,
              ),
            ],
          ),
          onTap: onEdit 
        ),
      ),
    );
  }
}
