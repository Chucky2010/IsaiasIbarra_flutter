import  'package:mi_proyecto/data/question_repository.dart';
import 'package:mi_proyecto/domain/question.dart';

class QuestionService {
  final QuestionRepository repository;

  QuestionService(this.repository);

  final List<Question> questions = [];

  Future<List<Question>> getQuestions() async {
    final questions = await repository.getQuestions();
    return questions;
  }
}

