import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Pruthvi(),
    debugShowCheckedModeBanner: false,
    title: 'Pruthvi',
  ));
}

class Pruthvi extends StatefulWidget {
  const Pruthvi({super.key});

  @override
  State<Pruthvi> createState() => _PruthviState();
}

class _PruthviState extends State<Pruthvi> {
  String display = '';
  String player = 'X';
  List<String> playBoard = List.filled(9, '');
  bool singlePlayer = false;
  int _seconds = 0;
  Timer? _timer;
  bool _isGameRunning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size);
    double height = size.height - 200;
    print(height);
    double width = size.width;
    print(width);
    double minSize = min(width, height);
    print(minSize);

    double timerFontSize = width * 0.05;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.1, // MediaQuery-based height calculation
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () => setState(() {
                        singlePlayer = true;
                      }),
                      child: Text('Single Player'),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Container(
                    height: height * 0.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () => setState(() {
                        singlePlayer = false;
                      }),
                      child: Text('Two Player'),
                    ),
                  ),
                ],
              ),
              Container(
                height: height * 0.1,
                alignment: Alignment.center,
                child: Text(
                  _formatTime(_seconds),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: timerFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: minSize * 44 / 50,
                  width: minSize * 44 / 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(minSize * 3 / 50),
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => ontap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            playBoard[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: height * 0.1, // MediaQuery-based height calculation
                alignment: Alignment.center, // Centering the reset button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => reset(),
                  child: Text('Reset Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ontap(int index) {
    if (playBoard[index] == '' && display == '') {
      if (!_isGameRunning) _startTimer();

      setState(() {
        playBoard[index] = player;
        player = (player == 'X') ? 'O' : 'X';
      });

      result();

      if (singlePlayer && player == 'O') {
        automatic();
      }
    }
  }

  Future<void> automatic() async {
    List<int> emptySpace = [];
    for (int i = 0; i < 9; i++) {
      if (playBoard[i] == '') {
        emptySpace.add(i);
      }
    }
    if (emptySpace.isNotEmpty) {
      await Future.delayed(Duration(seconds: 1));
      int index = emptySpace[Random().nextInt(emptySpace.length)];
      ontap(index);
    }
  }

  void result() {
    List<List<int>> winnerPlayer = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var board in winnerPlayer) {
      String first = playBoard[board[0]];
      String second = playBoard[board[1]];
      String third = playBoard[board[2]];

      if (first == second && second == third && first != '') {
        setState(() {
          display = first;
          _stopTimer();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Winner is $first'),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => reset(context),
                    child: Text('Reset'),
                  ),
                )
              ],
            ),
          );
        });
        return;
      }
    }

    if (!playBoard.contains('') && display == '') {
      setState(() {
        _stopTimer();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('It\'s a draw!'),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => reset(context),
                  child: Text('Reset'),
                ),
              )
            ],
          ),
        );
      });
    }
  }

  void reset([BuildContext? context]) {
    setState(() {
      player = 'X';
      display = '';
      playBoard = List.filled(9, '');
      _seconds = 0;
      _stopTimer();
      if (context != null) {
        Navigator.pop(context);
      }
    });
  }

  void _startTimer() {
    _isGameRunning = true;
    _timer = Timer.periodic(
      Duration(seconds: 1),
          (timer) {
        setState(() {
          _seconds++;
        });
      },
    );
  }

  void _stopTimer() {
    _isGameRunning = false;
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes < 10 ? '0' : ''}$minutes:${remainingSeconds < 10 ? '0' : ''}$remainingSeconds';
  }
}

