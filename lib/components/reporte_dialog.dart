import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_bloc.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_event.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_state.dart';
import 'package:mi_proyecto/domain/reporte.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:watch_it/watch_it.dart';

/// Clase para mostrar el diálogo de reportes de noticias
class ReporteDialog {
  /// Muestra un diálogo de reporte para una noticia
  static Future<void> mostrarDialogoReporte({
    required BuildContext context,
    required String noticiaId,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => di<ReporteBloc>(),
          child: _ReporteDialogContent(noticiaId: noticiaId),
        );
      },
    );
  }
}

class _ReporteDialogContent extends StatefulWidget {
  final String noticiaId;

  const _ReporteDialogContent({required this.noticiaId});

  @override
  State<_ReporteDialogContent> createState() => _ReporteDialogContentState();
}

class _ReporteDialogContentState extends State<_ReporteDialogContent> {
  // Estadísticas de reportes
  Map<String, int> _estadisticasReportes = {
    'NoticiaInapropiada': 0,
    'InformacionFalsa': 0,
    'Otro': 0,
  };
  bool _reporteEnviando = false;
  MotivoReporte? _ultimoMotivoReportado;

  @override
  void initState() {
    super.initState();
    // Cargar estadísticas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEstadisticasReportes();
    });
  }
  
  void _cargarEstadisticasReportes() {
    // Solicitar estadísticas de reportes
    context.read<ReporteBloc>().add(CargarEstadisticasReporte(
      noticiaId: widget.noticiaId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReporteBloc, ReporteState>(
      listener: (context, state) {
        if (state is ReporteSuccess) {
          // Solicitar actualización de estadísticas después de un reporte exitoso
          _cargarEstadisticasReportes();
          
          // Mostrar mensaje de éxito y cerrar el diálogo después de un tiempo
          SnackBarHelper.mostrarExito(
            context,
            mensaje: state.mensaje,
          );
          
          // cerramos el diálogo inmediatamente para que el usuario vea los contadores actualizados
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        } else if (state is ReporteError) {
          // Mostrar mensaje de error
          SnackBarHelper.mostrarError(
            context,
            mensaje: state.errorMessage,
          );
          setState(() {
            _reporteEnviando = false;
          });
        } else if (state is ReporteEstadisticasLoaded && state.noticiaId == widget.noticiaId) {
          // Actualizar contadores cuando se cargan las estadísticas
          // Convertir del enum MotivoReporte a strings para mostrar los contadores
          setState(() {
            _reporteEnviando = false;
            _estadisticasReportes = {
              'NoticiaInapropiada': state.estadisticas[MotivoReporte.noticiaInapropiada] ?? 0,
              'InformacionFalsa': state.estadisticas[MotivoReporte.informacionFalsa] ?? 0,
              'Otro': state.estadisticas[MotivoReporte.otro] ?? 0,
            };
          });
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFCEAE8), // Color rosa suave
        // Configurar un ancho máximo para el diálogo
        insetPadding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 24.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Reducir el padding interno
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Reportar Noticia',
                style: TextStyle(
                  fontSize: 16, // Reducir tamaño de fuente
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12), // Reducir espacio
              const Text(
                'Selecciona el motivo:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16), // Reducir espacio
              
              // Opciones de reporte con íconos y contadores - más compactas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMotivoButton(
                    context: context,
                    motivo: MotivoReporte.noticiaInapropiada,
                    icon: Icons.warning,
                    color: Colors.red,
                    label: 'Inapropiada',
                    iconNumber: '${_estadisticasReportes['NoticiaInapropiada']}',
                    isLoading: _reporteEnviando && _ultimoMotivoReportado == MotivoReporte.noticiaInapropiada,
                    smallSize: true, // Indicador para tamaño reducido
                  ),
                  _buildMotivoButton(
                    context: context,
                    motivo: MotivoReporte.informacionFalsa,
                    icon: Icons.info,
                    color: Colors.amber,
                    label: 'Falsa',
                    iconNumber: '${_estadisticasReportes['InformacionFalsa']}',
                    isLoading: _reporteEnviando && _ultimoMotivoReportado == MotivoReporte.informacionFalsa,
                    smallSize: true, // Indicador para tamaño reducido
                  ),
                  _buildMotivoButton(
                    context: context,
                    motivo: MotivoReporte.otro,
                    icon: Icons.flag,
                    color: Colors.blue,
                    label: 'Otro',
                    iconNumber: '${_estadisticasReportes['Otro']}',
                    isLoading: _reporteEnviando && _ultimoMotivoReportado == MotivoReporte.otro,
                    smallSize: true, // Indicador para tamaño reducido
                  ),
                ],
              ),
              
              const SizedBox(height: 16), // Reducir espacio
              
              // Botón para cerrar el diálogo
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _reporteEnviando ? null : () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 14, // Reducir tamaño
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivoButton({
    required BuildContext context,
    required MotivoReporte motivo,
    required IconData icon,
    required Color color,
    required String label,
    required String iconNumber,
    bool isLoading = false,
    bool smallSize = false, // Nuevo parámetro para tamaño reducido
  }) {
    // Definir tamaños según el parámetro smallSize
    final buttonSize = smallSize ? 50.0 : 60.0;
    final iconSize = smallSize ? 24.0 : 30.0;
    final badgeSize = smallSize ? 16.0 : 18.0;
    final fontSize = smallSize ? 10.0 : 12.0;
    
    return Column(
      children: [
        InkWell(
          onTap: _reporteEnviando 
              ? null 
              : () => _enviarReporte(context, motivo),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mostrar un indicador de carga si este botón está en proceso
                if (isLoading)
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                else
                  Icon(
                    icon,
                    color: color,
                    size: iconSize,
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        iconNumber,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: smallSize ? 6.0 : 8.0),
        Text(
          label,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }

  void _enviarReporte(BuildContext context, MotivoReporte motivo) {
    setState(() {
      _reporteEnviando = true;
      _ultimoMotivoReportado = motivo;
    });
    // Enviar el reporte usando el bloc
    context.read<ReporteBloc>().add(EnviarReporte(
          noticiaId: widget.noticiaId,
          motivo: motivo,
        ));
  }
}
