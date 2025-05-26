class Question {
  final String questionText; // Texto de la pregunta
  final List<String> answerOptions; // Opciones de respuesta
  final int correctAnswerIndex; // Índice de la respuesta correcta

  Question({
    required this.questionText,
    required this.answerOptions,
    required this.correctAnswerIndex,
  });

  // Método para verificar si una respuesta es correcta
  bool isCorrect(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }
}