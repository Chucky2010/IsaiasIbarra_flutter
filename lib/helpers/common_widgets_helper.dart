import 'package:flutter/material.dart';
import 'package:mi_proyecto/theme/theme.dart';

class CommonWidgetsHelper {
  //padding y margenes
  static EdgeInsets padding8 = const EdgeInsets.all(8);
  static EdgeInsets padding16 = const EdgeInsets.all(16);
  static EdgeInsets padding32 = const EdgeInsets.all(32);
  static const EdgeInsets paddingHorizontal32 = EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 0,
  );

  //espaciados
  static Widget buildSpacing8() {
    return const SizedBox(height: 8);
  }

  static Widget buildSpacing16() {
    return const SizedBox(height: 16);
  }

  static Widget buildSpacing32() {
    return const SizedBox(height: 32);
  }

  //containers o secciones
  static Widget paddingContainer32({
    required Widget child,
    required Color color,
  }) {
    return Container(padding: padding32, child: child);
  }

  static Widget paddingContainerHorizontal32({
    required List<Widget> children,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: paddingHorizontal32,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...children],
      ),
    );
  }

  static Widget seccionSubTitulo({required String title}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Text(title, style: theme.textTheme.headlineLarge);
      },
    );
  }

  static Widget seccionInfo({required IconData icon, required String text}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final iconTheme = AppTheme.infoIconTheme(context);
        return Row(
          children: [
            Icon(
              icon,
              color: iconTheme.color,
              size: iconTheme.size,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: theme.textTheme.titleMedium)),
          ],
        );
      },
    );
  }

  // Nuevo método para iconos de estado de error
  static Widget iconoNoConexion() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: padding16,
          decoration: AppTheme.iconDecoration(context),
          child: Icon(Icons.wifi_off, color: theme.colorScheme.primary, size: 64),
        );
      },
    );
  }

  static Widget verticalSpace(double height) {
    return SizedBox(height: height);
  }

  static Widget horizontalSpace(double width) {
    return SizedBox(width: width);
  }

  // Nuevo método para mensajes de error
  static Widget mensaje({
    required String titulo,
    required String mensaje,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Column(
          children: [
            Text(
              titulo,
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            buildSpacing16(),
            Padding(
              padding: paddingHorizontal32,
              child: Text(
                mensaje,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }
  static Widget seccionValoresSodep({
    required IconData icon,
    required String title,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: padding8,
              decoration: AppTheme.iconDecoration(context),
              child: Icon(icon, color: theme.colorScheme.primary, size: 24),
            ),
            buildSpacing16(),
            Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          ],
        );
      },
    );
  }

  static Widget copyrightFooter(BuildContext context) {
    final theme = Theme.of(context);
    // Color con transparencia para texto de copyright
    final Color copyrightColor = theme.colorScheme.onSurface.withAlpha(51);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fila de copyright
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.copyright_rounded, color: copyrightColor, size: 16),
            buildSpacing8(),
            Text(
              '2025 SODEP S.A.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: copyrightColor,
              ),
            ),
          ],
        ),

        buildSpacing8(),
        Center(
          child: Text(
            'Software Development & Products',
            style: theme.textTheme.bodySmall?.copyWith(color: copyrightColor),
          ),
        ),
        buildSpacing32(),
      ],
    );
  }

  //imagenes/logos
  static Widget sodepLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: Image.asset('assets/images/logo_sodep.png', height: 120)),
      ],
    );
  }

  //textos
  static Widget textoPrincipal(
    BuildContext context, {
    required String text,
    TextStyle? style,
  }) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.bodyMedium,
      textAlign: TextAlign.justify,
    );
  }
}
