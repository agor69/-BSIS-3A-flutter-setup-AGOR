import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop Quiz',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool quizStarted = false;
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which feature would help a coffee shop the most?',
      'answers': [
        'Online table reservation system',
        'Digital queue number system',
        'Inventory alerts for coffee beans and supplies',
        'Customer feedback form',
      ],
      'correct': 2,
    },
    {
      'question':
          'Which feature would help a coffee shop improve customer experience?',
      'answers': [
        'Mobile app for ordering ahead',
        'In-store Wi-Fi setup',
        'Loyalty program for repeat customers',
        'Daily specials board',
      ],
      'correct': 2,
    },
    {
      'question':
          'Which feature would help a coffee shop streamline operations?',
      'answers': [
        'Point-of-sale system with payment integration',
        'Social media marketing tools',
        'Employee scheduling app',
        'Customer seating layout planner',
      ],
      'correct': 0,
    },
  ];

  void startQuiz() {
    setState(() {
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      answered = false;
    });
  }

  void answerQuestion(int index) {
    if (!answered) {
      setState(() {
        answered = true;
        if (index == questions[currentQuestionIndex]['correct']) {
          score++;
        }
      });
    }
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        answered = false;
      } else {
        quizStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Coffee Shop Quiz'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7EFE5), Color(0xFFE3CAA5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(child: quizStarted ? buildQuizCard() : buildStartCard()),
      ),
    );
  }

  Widget buildStartCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome to the Quiz',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Your Score: $score', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: startQuiz,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuizCard() {
    final question = questions[currentQuestionIndex];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(4, (index) {
              Color? color;
              if (answered) {
                color = index == question['correct']
                    ? Colors.green
                    : Colors.red;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: answered ? null : () => answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(question['answers'][index]),
                ),
              );
            }),
            const SizedBox(height: 16),
            if (answered)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  currentQuestionIndex < questions.length - 1
                      ? 'Next Question'
                      : 'Finish Quiz',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
