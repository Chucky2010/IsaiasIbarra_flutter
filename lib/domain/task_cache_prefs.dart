import 'package:dart_mappable/dart_mappable.dart';

part 'task_cache_prefs.mapper.dart';

@MappableClass()
class TaskCachePrefs with TaskCachePrefsMappable {
  final String email;
  final List<String> misTareas;

  const TaskCachePrefs({
    required this.email,
    required this.misTareas,
  });
}