import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_event.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_bloc.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_event.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_state.dart';
import 'package:mi_proyecto/components/limite_reporte_dialog.dart';
import 'package:mi_proyecto/domain/reporte.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:watch_it/watch_it.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class ReporteDialog {
  static Future<void> mostrarDialogoReporte({
    required BuildContext context,
    required Noticia noticia,
  }) async {
    final int? totalReportes = noticia.contadorReportes;
    if (totalReportes! >= 3) {
      return LimiteReportesDialog.mostrar(context);
    }
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => di<ReporteBloc>(),
          child: _ReporteDialogContent(
            noticiaId: noticia.id!,
            noticia: noticia,
          ),
        );
      },
    );
  }
}

class _ReporteDialogContent extends StatefulWidget {
  final String noticiaId;
  final Noticia noticia;

  const _ReporteDialogContent({required this.noticiaId, required this.noticia});

  @override
  State<_ReporteDialogContent> createState() => _ReporteDialogContentState();
}

class _ReporteDialogContentState extends State<_ReporteDialogContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReporteBloc>().add(
        CargarEstadisticasReporte(noticia: widget.noticia),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReporteBloc, ReporteState>(
      listener: (context, state) {
        if (state is ReporteSuccess) {
          SnackBarHelper.mostrarExito(context, mensaje: state.mensaje);
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        } else if (state is ReporteError) {
          SnackBarHelper.mostrarError(context, mensaje: state.error.message);
        } else if (state is NoticiaReportesActualizada &&
            state.noticia.id == widget.noticiaId) {
          context.read<NoticiaBloc>().add(
            ActualizarContadorReportesEvent(
              state.noticia.id!,
              state.contadorReportes,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ReporteLoading;
        final motivoActual = isLoading ? (state).motivoActual : null;

        Map<String, int> estadisticas = {
          'NoticiaInapropiada': 0,
          'InformacionFalsa': 0,
          'Otro': 0,
        };

        if (state is ReporteEstadisticasLoaded &&
            state.noticia.id == widget.noticiaId) {
          estadisticas = {
            'NoticiaInapropiada':
                state.estadisticas[MotivoReporte.noticiaInapropiada] ?? 0,
            'InformacionFalsa':
                state.estadisticas[MotivoReporte.informacionFalsa] ?? 0,
            'Otro': state.estadisticas[MotivoReporte.otro] ?? 0,
          };
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFCEAE8),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 70.0,
            vertical: 24.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Reportar Noticia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Selecciona el motivo:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMotivoButton(
                      context: context,
                      motivo: MotivoReporte.noticiaInapropiada,
                      icon: Icons.warning,
                      color: Colors.red,
                      label: 'Inapropiada',
                      iconNumber: '${estadisticas['NoticiaInapropiada']}',
                      isLoading:
                          isLoading &&
                          motivoActual == MotivoReporte.noticiaInapropiada,
                      smallSize: true,
                    ),
                    _buildMotivoButton(
                      context: context,
                      motivo: MotivoReporte.informacionFalsa,
                      icon: Icons.info,
                      color: Colors.amber,
                      label: 'Falsa',
                      iconNumber: '${estadisticas['InformacionFalsa']}',
                      isLoading:
                          isLoading &&
                          motivoActual == MotivoReporte.informacionFalsa,
                      smallSize: true,
                    ),
                    _buildMotivoButton(
                      context: context,
                      motivo: MotivoReporte.otro,
                      icon: Icons.flag,
                      color: Colors.blue,
                      label: 'Otro',
                      iconNumber: '${estadisticas['Otro']}',
                      isLoading:
                          isLoading && motivoActual == MotivoReporte.otro,
                      smallSize: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: Colors.brown, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    bool smallSize = false,
  }) {
    final buttonSize = smallSize ? 50.0 : 60.0;
    final iconSize = smallSize ? 24.0 : 30.0;
    final badgeSize = smallSize ? 16.0 : 18.0;
    final fontSize = smallSize ? 10.0 : 12.0;

    return Column(
      children: [
        InkWell(
          onTap: isLoading ? null : () => _enviarReporte(context, motivo),
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
                  Icon(icon, color: color, size: iconSize),
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
        Text(label, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }

  void _enviarReporte(BuildContext context, MotivoReporte motivo) {
    context.read<ReporteBloc>().add(
      EnviarReporte(noticia: widget.noticia, motivo: motivo),
    );
  }
}
