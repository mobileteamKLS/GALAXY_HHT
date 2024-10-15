import 'dart:async';
import 'package:flutter/material.dart';

class InactivityTimerManager {
  Timer? _inactivityTimer;
  final int timeoutMinutes;
  final BuildContext context;
  final VoidCallback onTimeout;

  InactivityTimerManager({
    required this.context,
    required this.timeoutMinutes,
    required this.onTimeout,
  });

  // Start the inactivity timer
  void startTimer() {
    _inactivityTimer?.cancel(); // Cancel any existing timer
    _inactivityTimer = Timer(Duration(minutes: timeoutMinutes), _handleTimeout);
  }

  // Reset the inactivity timer
  void resetTimer() {
    startTimer(); // Restart the timer
  }

  // Handle what happens when the timer expires
  void _handleTimeout() {
    onTimeout(); // Call the provided callback for timeout action
  }

  // Stop the timer if needed
  void stopTimer() {
    _inactivityTimer?.cancel();
  }
}
