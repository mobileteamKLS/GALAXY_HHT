import 'package:flutter/material.dart';
import 'package:galaxy/manager/timermanager.dart';

class LifecycleWatcher with WidgetsBindingObserver {
  final InactivityTimerManager? timerManager;

  LifecycleWatcher({required this.timerManager}) {
    // Start observing the lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App is resumed, reset or restart the timer
      timerManager?.resetTimer();
      print('App resumed, timer reset');
    } else if (state == AppLifecycleState.paused) {
      // App is paused, stop the timer
      timerManager?.stopTimer();
      print('App paused, timer stopped');
    } else if (state == AppLifecycleState.inactive) {
      // App is inactive (e.g., during phone call), stop the timer
      timerManager?.stopTimer();
      print('App inactive, timer stopped');
    }
  }

  void dispose() {
    // Remove observer when not needed
    WidgetsBinding.instance.removeObserver(this);
  }
}