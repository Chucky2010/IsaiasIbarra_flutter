import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_proyecto/bloc/theme/theme_event.dart';
import 'package:mi_proyecto/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<InitializeThemeEvent>(_onInitializeTheme);
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    // Cambiar entre modo claro y oscuro
    final newThemeMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newThemeMode));
    
    // Guardar la preferencia
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newThemeMode == ThemeMode.dark);
  }

  Future<void> _onInitializeTheme(InitializeThemeEvent event, Emitter<ThemeState> emit) async {
    // Cargar la preferencia de tema guardada
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(state.copyWith(themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light));
  }
}
