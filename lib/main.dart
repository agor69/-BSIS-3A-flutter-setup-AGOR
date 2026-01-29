import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Root widget - entry point for the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Quiz',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: MyHomePage(), // The homepage where the quiz runs
    );
  }
}

// Stateful widget for quiz logic
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool quizStarted = false; // Determines if the quiz has started
  int currentQuestionIndex = 0; // Tracks the current question index
  int score = 0; // The player's score
  bool answered = false; // Flag to check if the question has been answered

  // List of questions, answers, and correct answer index
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which feature would help a coffee shop the most?:',
      'answers': [
        'Online table reservation system',
        'Digital queue number system',
        'Inventory alerts for coffee beans and supplies', // Correct answer (Index 2)
        'Customer feedback form',
      ],
      'correct': 2, // Index of the correct answer
    },
    {
      'question':
          'Which feature would help a coffee shop improve customer experience?:',
      'answers': [
        'Mobile app for ordering ahead',
        'In-store Wi-Fi setup',
        'Loyalty program for repeat customers', // Correct answer (Index 2)
        'Daily specials board',
      ],
      'correct': 2, // Index of the correct answer
    },
    {
      'question':
          'Which feature would help a coffee shop streamline operations?:',
      'answers': [
        'Point-of-sale system with payment integration', // Correct answer (Index 0)
        'Social media marketing tools',
        'Employee scheduling app',
        'Customer seating layout planner',
      ],
      'correct': 0, // Index of the correct answer
    },
  ];

  // Start or restart the quiz
  void startQuiz() {
    setState(() {
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      answered = false;
    });
  }

  // Handle the answer selection
  void answerQuestion(int index) {
    if (!answered) {
      setState(() {
        answered = true; // Lock the answers after one is selected
        // Check if the selected answer is correct
        if (index == questions[currentQuestionIndex]['correct']) {
          score++; // Increase the score for a correct answer
        }
      });
    }
  }

  // Move to the next question or end the quiz
  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++; // Move to the next question
        answered = false; // Allow answering of the next question
      } else {
        quizStarted = false; // End the quiz if no more questions
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Coffee Shop Quiz'),
      ),
      body: Center(
        child: quizStarted
            ? buildQuizView() // Display the quiz if started
            : buildStartOrEndView(), // Display start/end screen
      ),
    );
  }

  // Start/End view: Shows the Start button and score at the end
  Widget buildStartOrEndView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!quizStarted)
          Text(
            'Your Score: $score',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: startQuiz, // Start or restart the quiz
          child: Text(quizStarted ? 'Restart Quiz' : 'Start Quiz'),
        ),
      ],
    );
  }

  // Quiz view: Shows the current question and answers
  Widget buildQuizView() {
    final question = questions[currentQuestionIndex];
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question['question'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Dynamically create answer buttons
          ...List.generate(4, (index) {
            Color? buttonColor;
            if (answered) {
              buttonColor = index == question['correct']
                  ? Colors
                        .green // Correct answer -> green
                  : Colors.red; // Incorrect answer -> red
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: ElevatedButton(
                onPressed: answered
                    ? null
                    : () => answerQuestion(index), // Disable after answering
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      buttonColor, // Flash color based on answer correctness
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(question['answers'][index]), // Display answer text
              ),
            );
          }),
          SizedBox(height: 20),
          // Display the Next button after answering
          if (answered)
            ElevatedButton(
              onPressed: nextQuestion, // Move to next question or end quiz
              child: Text(
                currentQuestionIndex < questions.length - 1
                    ? 'Next'
                    : 'End Quiz',
              ),
            ),
        ],
      ),
    );
  }
}
