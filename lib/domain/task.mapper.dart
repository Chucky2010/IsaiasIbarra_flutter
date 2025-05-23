// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'task.dart';

class TaskMapper extends ClassMapperBase<Task> {
  TaskMapper._();

  static TaskMapper? _instance;
  static TaskMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Task';

  static String _$titulo(Task v) => v.titulo;
  static const Field<Task, String> _f$titulo = Field('titulo', _$titulo);
  static String _$tipo(Task v) => v.tipo;
  static const Field<Task, String> _f$tipo =
      Field('tipo', _$tipo, opt: true, def: 'normal');
  static String? _$descripcion(Task v) => v.descripcion;
  static const Field<Task, String> _f$descripcion =
      Field('descripcion', _$descripcion, opt: true);
  static DateTime? _$fecha(Task v) => v.fecha;
  static const Field<Task, DateTime> _f$fecha =
      Field('fecha', _$fecha, opt: true);
  static DateTime? _$fechaLimite(Task v) => v.fechaLimite;
  static const Field<Task, DateTime> _f$fechaLimite =
      Field('fechaLimite', _$fechaLimite, opt: true);
  static List<String>? _$pasos(Task v) => v.pasos;
  static const Field<Task, List<String>> _f$pasos =
      Field('pasos', _$pasos, opt: true);

  @override
  final MappableFields<Task> fields = const {
    #titulo: _f$titulo,
    #tipo: _f$tipo,
    #descripcion: _f$descripcion,
    #fecha: _f$fecha,
    #fechaLimite: _f$fechaLimite,
    #pasos: _f$pasos,
  };

  static Task _instantiate(DecodingData data) {
    return Task(
        titulo: data.dec(_f$titulo),
        tipo: data.dec(_f$tipo),
        descripcion: data.dec(_f$descripcion),
        fecha: data.dec(_f$fecha),
        fechaLimite: data.dec(_f$fechaLimite),
        pasos: data.dec(_f$pasos));
  }

  @override
  final Function instantiate = _instantiate;

  static Task fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Task>(map);
  }

  static Task fromJson(String json) {
    return ensureInitialized().decodeJson<Task>(json);
  }
}

mixin TaskMappable {
  String toJson() {
    return TaskMapper.ensureInitialized().encodeJson<Task>(this as Task);
  }

  Map<String, dynamic> toMap() {
    return TaskMapper.ensureInitialized().encodeMap<Task>(this as Task);
  }

  TaskCopyWith<Task, Task, Task> get copyWith =>
      _TaskCopyWithImpl<Task, Task>(this as Task, $identity, $identity);
  @override
  String toString() {
    return TaskMapper.ensureInitialized().stringifyValue(this as Task);
  }

  @override
  bool operator ==(Object other) {
    return TaskMapper.ensureInitialized().equalsValue(this as Task, other);
  }

  @override
  int get hashCode {
    return TaskMapper.ensureInitialized().hashValue(this as Task);
  }
}

extension TaskValueCopy<$R, $Out> on ObjectCopyWith<$R, Task, $Out> {
  TaskCopyWith<$R, Task, $Out> get $asTask =>
      $base.as((v, t, t2) => _TaskCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TaskCopyWith<$R, $In extends Task, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get pasos;
  $R call(
      {String? titulo,
      String? tipo,
      String? descripcion,
      DateTime? fecha,
      DateTime? fechaLimite,
      List<String>? pasos});
  TaskCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TaskCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Task, $Out>
    implements TaskCopyWith<$R, Task, $Out> {
  _TaskCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Task> $mapper = TaskMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get pasos =>
      $value.pasos != null
          ? ListCopyWith($value.pasos!,
              (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(pasos: v))
          : null;
  @override
  $R call(
          {String? titulo,
          String? tipo,
          Object? descripcion = $none,
          Object? fecha = $none,
          Object? fechaLimite = $none,
          Object? pasos = $none}) =>
      $apply(FieldCopyWithData({
        if (titulo != null) #titulo: titulo,
        if (tipo != null) #tipo: tipo,
        if (descripcion != $none) #descripcion: descripcion,
        if (fecha != $none) #fecha: fecha,
        if (fechaLimite != $none) #fechaLimite: fechaLimite,
        if (pasos != $none) #pasos: pasos
      }));
  @override
  Task $make(CopyWithData data) => Task(
      titulo: data.get(#titulo, or: $value.titulo),
      tipo: data.get(#tipo, or: $value.tipo),
      descripcion: data.get(#descripcion, or: $value.descripcion),
      fecha: data.get(#fecha, or: $value.fecha),
      fechaLimite: data.get(#fechaLimite, or: $value.fechaLimite),
      pasos: data.get(#pasos, or: $value.pasos));

  @override
  TaskCopyWith<$R2, Task, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TaskCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
