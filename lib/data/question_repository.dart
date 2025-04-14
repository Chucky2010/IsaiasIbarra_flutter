import 'package:mi_proyecto/domain/question.dart';

class QuestionRepository {
  final List<Question> questions;
    QuestionRepository() : questions=[] {
    questions.addAll(
      [
      Question(
        questionText: '¿Cuál es la capital de Francia?',
        answerOptions: ['Madrid', 'París', 'Roma'],
        correctAnswerIndex: 1, // La respuesta correcta es 'París'
      ),
      Question(
        questionText: '¿Qué lenguaje se usa en Flutter?',
        answerOptions: ['Java', 'Dart', 'Python', 'C++'],
        correctAnswerIndex: 1, // La respuesta correcta es 'Dart'
      ),
      Question(
        questionText: '¿Cuántos planetas hay en el sistema solar?',
        answerOptions: ['7', '8', '9', '10'],
        correctAnswerIndex: 1, // La respuesta correcta es '8'
      ),
      Question(
        questionText: '¿Qué planeta es conocido como el planeta rojo?',
        answerOptions:  ['Júpiter', 'Marte', 'Venus'] ,
        correctAnswerIndex: 1, // La respuesta correcta es 'Marte'
      ),
    ]
    );
  }

  List<Question> getQuestions() {
    return questions; // Devuelve la lista de preguntas
  }
}