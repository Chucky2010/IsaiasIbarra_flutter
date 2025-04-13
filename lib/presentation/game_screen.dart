// import 'package:flutter/material.dart';
// import 'package:mi_proyecto/services/question_service.dart';
// import 'package:mi_proyecto/domain/question.dart';
// import 'package:mi_proyecto/presentation/result_screen.dart';

// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});

//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   final QuestionService _questionService = QuestionService();
//   late List<Question> _questions;
//   int _currentQuestionIndex = 0;
//   int _score = 0;

//   @override
//   void initState() {
//     super.initState();
//     _questions = _questionService.getQuestions(); // Obtiene las preguntas del servicio
//   }

//   void _answerQuestion(int selectedIndex) {
//     // Verifica si la respuesta seleccionada es correcta
//     if (_questions[_currentQuestionIndex].correctAnswerIndex == selectedIndex) {
//       _score++;
//     }

//     // Avanza a la siguiente pregunta o muestra la pantalla de resultados
//     if (_currentQuestionIndex < _questions.length - 1) {
//       setState(() {
//         _currentQuestionIndex++;
//       });
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(score: _score, total: _questions.length),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final question = _questions[_currentQuestionIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Juego de Preguntas'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               question.questionText, // Muestra el texto de la pregunta
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...question.answerOptions.asMap().entries.map((entry) {
//               final index = entry.key;
//               final option = entry.value;
//               return ElevatedButton(
//                 onPressed: () => _answerQuestion(index), // Maneja la respuesta seleccionada
//                 child: Text(option),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }