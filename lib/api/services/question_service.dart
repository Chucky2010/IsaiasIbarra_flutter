import 'package:mi_proyecto/data/question_repository.dart';
import 'package:mi_proyecto/domain/question.dart';

class QuestionService {
  final QuestionRepository _repository = QuestionRepository();

  List<Question> getQuestions() {
    // Obtiene las preguntas del repositorio
    return _repository.getQuestions();
  }
}