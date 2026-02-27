import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/theme/app_colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _secondsRemaining = 600; // 10 minutes
  Timer? _timer;
  int _currentQuestion = 1;
  final int _totalQuestions = 15;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Academic Quiz Beta', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text(_formatTime(_secondsRemaining), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _currentQuestion / _totalQuestions,
            backgroundColor: AppColors.border,
            color: AppColors.primary,
            minHeight: 6,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question $_currentQuestion of $_totalQuestions', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  const Text(
                    'What is the primary difference between a microcontroller and a microprocessor in an embedded system project?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  _buildOption('A', 'Microcontrollers have integrated memory and peripherals.'),
                  _buildOption('B', 'Microprocessors are faster than microcontrollers.'),
                  _buildOption('C', 'Microcontrollers are only used for digital signals.'),
                  _buildOption('D', 'Microprocessors do not require an operating system.'),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildOption(String letter, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
            child: Center(child: Text(letter, style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () {}, child: const Text('Skip')),
          ElevatedButton(
            onPressed: () {
              if (_currentQuestion < _totalQuestions) setState(() => _currentQuestion++);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Next Question', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
