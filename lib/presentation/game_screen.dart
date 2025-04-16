import 'package:flutter/material.dart';
import 'package:mi_proyecto/services/question_service.dart';
import 'package:mi_proyecto/domain/question.dart';
import 'package:mi_proyecto/presentation/result_screen.dart';
import 'package:mi_proyecto/constants.dart';

class GameScreen extends StatefulWidget {
   const GameScreen({super.key});
 
   @override
   GameScreenState createState() => GameScreenState();
 }
 
 class GameScreenState extends State<GameScreen> {
   final QuestionService _questionService = QuestionService();
   late List<Question> questionsList;
   int currentQuestionIndex = 0;
   int userScore = 0;
   String questionCounterText = '';
   int? selectedAnswerIndex;
   bool? respCorrecta;
 
   @override
   void initState() {
     super.initState();
     questionsList = _questionService.getQuestions();
     loadQuestions();
   }
 
   void handleAnswer(int selectedIndex) {
     setState(() {
       selectedAnswerIndex = selectedIndex;
       respCorrecta =
           questionsList[currentQuestionIndex].correctAnswerIndex == selectedIndex;
     });
 
    // Mensaje del SnackBar
    final String snackBarMessage = 
    respCorrecta == true ? '¡Correcto!' : 'Incorrecto';

    // Muestra el SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          snackBarMessage,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: respCorrecta == true ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1), // Duración del SnackBar
      ),
    );
  
     loadNextQuestion(selectedIndex);
   }
 
   void loadQuestions() {
     setState(() {
       questionCounterText =
           'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
     });
   }
 
   void loadNextQuestion(int selectedIndex) {

     Future.delayed(const Duration(seconds: 1), () {
       if (respCorrecta == true) {
         userScore++;
       }
 
       if (currentQuestionIndex < questionsList.length - 1) {
         setState(() {
           currentQuestionIndex++;
           selectedAnswerIndex = null;
           respCorrecta = null;
           questionCounterText =
               'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
         });
       } else {
        if (!mounted) return;
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) =>  ResultScreen(
              finalScore: userScore,
              totalQuestions: questionsList.length,
           )),
         );
       }
     });
   }
 
   @override
   Widget build(BuildContext context) {
     final Question currentQuestion = questionsList[currentQuestionIndex];
     return Scaffold(
       backgroundColor: Colors.white,
       appBar: AppBar(
         title: const Text(Constants.titleAppGame),
         backgroundColor: Colors.blue,
         centerTitle: true,
       ),
       body: Center(
         child: Padding(
           padding: const EdgeInsets.all(16),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text(
                 questionCounterText,
                 style: const TextStyle(fontSize: 16, color: Colors.grey),
               ),
                const SizedBox(height: 16),
               Text(
                 currentQuestion.questionText,
                 style: const TextStyle(
                   fontSize: 20,
                   fontWeight: FontWeight.bold,
                   color: Colors.black,
                 ),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 24),
               Column(
                 
                 children: List.generate(
                   currentQuestion.answerOptions.length,
                   (index) => Padding(
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     child: ElevatedButton(
                       onPressed:
                           selectedAnswerIndex == null
                               ? () => handleAnswer(index)
                               : null,
                       style: ButtonStyle(
                         backgroundColor: WidgetStateProperty.resolveWith<Color>(
                           (Set<WidgetState> states) {
                             if (selectedAnswerIndex == index) {
                               return respCorrecta == true
                                   ? Colors.green
                                   : Colors.red;
                             }
                             return Colors.blue;
                           },
                         ),
                         padding: WidgetStateProperty.all(
                           const EdgeInsets.symmetric(
                             vertical: 16,
                             horizontal: 24,
                           ),
                         ),
                         shape: WidgetStateProperty.all(
                           RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                       child: Text(
                         currentQuestion.answerOptions[index],
                         style: const TextStyle(
                           fontSize: 16,
                           color: Colors.white,
                         ),
                       ),
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
 }
