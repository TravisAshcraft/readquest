// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/option_card.dart';
import '../models/quiz_question.dart';
import '../services/quiz_service.dart';     // fetchQuiz()
import '../services/progress_service.dart'; // submitProgress & completeBook

class QuizScreen extends StatefulWidget {
  final String bookTitle;
  final String readerName;
  final String bookId;

  const QuizScreen({
    Key? key,
    required this.bookTitle,
    required this.readerName,
    required this.bookId,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<QuizQuestion>> _futureQuestions;
  int _currentIndex = 0;
  int _selectedIndex = -1;

  // ← Option A: running total of points
  int _totalScore = 0;

  @override
  void initState() {
    super.initState();
    _futureQuestions = fetchQuiz(widget.bookTitle);
  }

  Future<void> _next(List<QuizQuestion> questions) async {
    if (_selectedIndex < 0) return; // guard: no selection

    final isLast = _currentIndex == questions.length - 1;

    // calculate this question’s points
    final earnedPoints = (questions[_currentIndex].options[_selectedIndex] ==
        questions[_currentIndex].answer)
        ? 10
        : 0;

    // add to running total
    _totalScore += earnedPoints;

    if (!isLast) {
      setState(() {
        _currentIndex++;
        _selectedIndex = -1;
      });
      return;
    }

    // LAST question: submit the accumulated total
    try {
      await submitProgress(
        readerName:     widget.readerName,
        completedTopic: widget.bookTitle,
        pointsEarned:   _totalScore,
        newXp:          _totalScore,
      );
    } catch (e) {
      debugPrint('Error submitting progress: $e');
    }

    try {
      await completeBook(
        readerName: widget.readerName,
        bookId:     widget.bookId,
        score:      _totalScore,
      );
    } catch (e) {
      debugPrint('Error completing book: $e');
    }

    Navigator.of(context).pop(); // back to Dashboard
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizQuestion>>(
      future: _futureQuestions,
      builder: (context, snap) {
        // loading
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.bookTitle),
              backgroundColor: AppColors.primaryPeach,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // error
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.bookTitle),
              backgroundColor: AppColors.primaryPeach,
            ),
            body: Center(child: Text('Error: ${snap.error}')),
          );
        }

        // got questions
        final questions = snap.data!;
        final q = questions[_currentIndex];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryPeach,
            title: Text('Question ${_currentIndex + 1}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.question,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(q.options.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: OptionCard(
                      text:     q.options[i],
                      selected: i == _selectedIndex,
                      onTap:    () => setState(() => _selectedIndex = i),
                    ),
                  );
                }),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedIndex >= 0
                        ? () => _next(questions)
                        : null,
                    child: Text(
                      _currentIndex < questions.length - 1
                          ? 'Next'
                          : 'Finish',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPeach,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
