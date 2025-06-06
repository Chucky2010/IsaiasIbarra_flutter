import 'package:flutter/material.dart';
import 'package:mi_proyecto/theme/colors.dart';
import 'package:mi_proyecto/theme/text.style.dart';

class AppTheme {
  // Tema claro (existente renombrado)
  static ThemeData lightTheme = bootcampTheme;

  // Tema oscuro nuevo
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryLightBlue,
    scaffoldBackgroundColor: AppColors.gray16,
    disabledColor: AppColors.gray12,

    // Barra de navegación en modo oscuro
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.gray15,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.gray01,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),

    // Botones de radio y checkbox en modo oscuro
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLightBlue;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        return AppColors.gray10;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLightBlue;
        } else if (states.contains(WidgetState.pressed)) {
          return AppColors.blue11;
        } else if (states.contains(WidgetState.hovered)) {
          return AppColors.blue09;
        } else if (states.contains(WidgetState.focused)) {
          return AppColors.primaryLightBlue;
        }
        return AppColors.gray10;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLightBlue;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        return AppColors.gray10;
      }),
      side: const BorderSide(color: AppColors.gray10),
    ),

    // Cards en modo oscuro
    cardTheme: CardThemeData(
      color: AppColors.gray14,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.gray12),
      ),
    ),

    // Botones en modo oscuro
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.gray13;
          }
          return AppColors.primaryLightBlue;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.gray01),
      ),
    ),

    // Pestañas en modo oscuro
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelStyle: AppTextStyles.bodyLgSemiBold,
      unselectedLabelStyle: AppTextStyles.bodyLg,
      labelColor: AppColors.primaryLightBlue,
      unselectedLabelColor: AppColors.gray07,
      indicator: const BoxDecoration(
        color: AppColors.blue16,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),

    // Botones de texto en modo oscuro
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          AppTextStyles.bodyLgMedium.copyWith(
            color: AppColors.primaryLightBlue,
          ),
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.primaryLightBlue),
      ),
    ),

    // Texto en modo oscuro
    textTheme: TextTheme(
      // Display styles
      displayLarge: AppTextStyles.heading3xl.copyWith(color: AppColors.gray03),
      displayMedium: AppTextStyles.heading2xl.copyWith(color: AppColors.gray03),
      displaySmall: AppTextStyles.headingXl.copyWith(color: AppColors.gray03),

      // Headline styles
      headlineLarge: AppTextStyles.headingLg.copyWith(color: AppColors.gray03),
      headlineMedium: AppTextStyles.headingMd.copyWith(color: AppColors.gray03),
      headlineSmall: AppTextStyles.headingSm.copyWith(color: AppColors.gray03),

      // Body styles
      bodyLarge: AppTextStyles.bodyLg.copyWith(color: AppColors.gray03),
      bodyMedium: AppTextStyles.bodyMd.copyWith(color: AppColors.gray03),
      bodySmall: AppTextStyles.bodySm.copyWith(color: AppColors.gray05),

      // Subtitle styles
      titleLarge: AppTextStyles.bodyLgMedium.copyWith(color: AppColors.gray03),
      titleMedium: AppTextStyles.bodyMdMedium.copyWith(color: AppColors.gray03),
      titleSmall: AppTextStyles.bodyXs.copyWith(color: AppColors.gray05),

      // Label styles
      labelLarge: AppTextStyles.bodyLgSemiBold.copyWith(
        color: AppColors.gray03,
      ),
      labelMedium: AppTextStyles.bodyMdSemiBold.copyWith(
        color: AppColors.gray03,
      ),
      labelSmall: AppTextStyles.bodyXsSemiBold.copyWith(
        color: AppColors.gray05,
      ),
    ),

    // Esquema de colores en modo oscuro
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLightBlue,
      secondary: AppColors.blue09,
      error: AppColors.error,
      surface: AppColors.gray14,
      // Usar estas propiedades en su lugar:
      surfaceContainer: AppColors.gray16, // Reemplazo de background
      surfaceTint: AppColors.gray14, // Color para dar tinte a las superficies

      onPrimary: AppColors.gray01,
      onSecondary: AppColors.gray01,
      onError: AppColors.gray01,
      outline: AppColors.gray10,
      shadow: Colors.black54,
    ),
  );

  // El tema bootcampTheme existente se mantiene igual
  static ThemeData bootcampTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
    disabledColor: AppColors.neutralGray,
    //Barra de navegación
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDarkBlue,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.gray01,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
    //botones de radio y checkbox
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        return AppColors.gray05;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.pressed)) {
          return AppColors.primaryActive;
        } else if (states.contains(WidgetState.hovered)) {
          return AppColors.primaryHover;
        } else if (states.contains(WidgetState.focused)) {
          return AppColors.primary;
        }
        return AppColors.gray05;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        return AppColors.gray01;
      }),
      side: const BorderSide(color: AppColors.gray05),
    ),
    //cards
    cardTheme: CardThemeData(
      color: AppColors.gray01,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.gray05),
      ),
    ),
    //botones
    filledButtonTheme: FilledButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.gray01,
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: AppColors.gray08,
        textStyle: AppTextStyles.bodyLgMedium.copyWith(color: AppColors.gray01),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ), // Esto quita completamente el redondeo
        ),
      ),
    ),
    //pestañas
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelStyle: AppTextStyles.bodyLgSemiBold,
      unselectedLabelStyle: AppTextStyles.bodyLg,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.gray14,
      indicator: const BoxDecoration(
        color: AppColors.blue02,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    //botones de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: AppTextStyles.bodyLgMedium.copyWith(
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    //texto
    textTheme: TextTheme(
      // Display styles
      displayLarge: AppTextStyles.heading3xl,
      displayMedium: AppTextStyles.heading2xl,
      displaySmall: AppTextStyles.headingXl,

      // Headline styles
      headlineLarge: AppTextStyles.headingLg,
      headlineMedium: AppTextStyles.headingMd,
      headlineSmall: AppTextStyles.headingSm,

      // Body styles
      bodyLarge: AppTextStyles.bodyLg,
      bodyMedium: AppTextStyles.bodyMd,
      bodySmall: AppTextStyles.bodySm,

      // Subtitle styles
      titleLarge: AppTextStyles.bodyLgMedium,
      titleMedium: AppTextStyles.bodyMdMedium,
      titleSmall: AppTextStyles.bodyXs,

      // Label styles (button text, etc.)
      labelLarge: AppTextStyles.bodyLgSemiBold,
      labelMedium: AppTextStyles.bodyMdSemiBold,
      labelSmall: AppTextStyles.bodyXsSemiBold,
    ),

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDarkBlue,
      secondary: AppColors.primaryLightBlue,
      error: AppColors.error,
      surface: AppColors.surface,
      onPrimary: AppColors.gray01,
      onSecondary: AppColors.gray01,
      onError: AppColors.gray01,
    ),
  );
  //decoraciones reutilizables
  static final BoxDecoration sectionBorderGray05 = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.gray05),
    color: Colors.white, // Fondo blanco
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(51), // Sombra suave
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Estilo para iconos con fondo pequeño
  static BoxDecoration iconDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withAlpha(51),
      borderRadius: BorderRadius.circular(10),
    );
  }

  // Estilo para iconos sin fondo pequeños
  static IconThemeData infoIconTheme(BuildContext context) {
    return IconThemeData(
      color: Theme.of(context).colorScheme.primary,
      size: 24,
    );
  }

  // Estilo para copyright
  static Color copyrightColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withAlpha(51);
  }
}
