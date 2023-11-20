import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int initTime = 1500;
  int repeatTime = initTime;
  int startTime = initTime;
  int totalPomodors = 0;
  bool timerOnOff = false;
  late Timer timer;

  void onClick(Timer timer) {
    if (startTime == 0) {
      setState(() {
        startTime = repeatTime;
        totalPomodors = totalPomodors + 1;
        timerOnOff = !timerOnOff;

        timer.cancel();
      });
    } else {
      setState(() {
        startTime = startTime - 1;
      });
    }
  }

  void onPlayButton() {
    timerOnOff = !timerOnOff;
    timer = Timer.periodic(const Duration(seconds: 1), onClick);
  }

  void onPauseButton() {
    setState(() {
      timerOnOff = !timerOnOff;
      timer.cancel();
    });
  }

  void onStopButton() {
    setState(() {
      startTime = repeatTime;
      totalPomodors = 0;
      timerOnOff = !timerOnOff;
      timer.cancel();
    });
  }

  TextEditingController customRepeatTime = TextEditingController();

  void onCustomTimeChanged(String input) {
    setState(() {
      repeatTime = int.tryParse(input) ?? initTime;
    });
  }

  void _showInputDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController customStartTime = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Time'),
          content: TextField(
            controller: customStartTime,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Seconds',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  startTime = int.tryParse(customStartTime.text) ?? initTime;
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: customRepeatTime,
                  onChanged: onCustomTimeChanged,
                  decoration: const InputDecoration(
                    labelText: 'Repeat Time',
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                _showInputDialog(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    format(startTime),
                    style: TextStyle(
                      fontSize: 89,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: timerOnOff ? onPauseButton : onPlayButton,
                      iconSize: 120,
                      color: Theme.of(context).cardColor,
                      icon: timerOnOff
                          ? const Icon(Icons.pause_circle_outline_rounded)
                          : const Icon(Icons.play_circle_outline_rounded),
                    ),
                    IconButton(
                      onPressed: onStopButton,
                      iconSize: 120,
                      color: Theme.of(context).cardColor,
                      icon: const Icon(Icons.stop_circle_rounded),
                    ),
                  ],
                ),
              )),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                        Text(
                          '$totalPomodors',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
