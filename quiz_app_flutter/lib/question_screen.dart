import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import 'dart:async';
import 'dart:math';

import 'question.dart';
import 'question_screen_utility.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  final String apiUrl;

  QuestionScreen({Key key, @required this.apiUrl}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Future<List<Question>> futureQuizQuestions;
  num currentQuestionNum = 0;
  num totalCorrectAnswer = 0;
  List<String> shuffledAnswerList;
  Map<int, String> ResultDataDict = {};

  var stopWatch = Stopwatch();
  String timeToDisplay = '00:00:00';
  final interval = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    futureQuizQuestions = fetchQuestions(widget.apiUrl);
    //https://opentdb.com/api.php?amount=10&category=10&type=boolean
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Question'),
        backgroundColor: Color(0xFF16A0D0),
      ),
      body: FutureBuilder<List<Question>>(
        future: futureQuizQuestions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!stopWatch.isRunning) {
              stopWatch.start();
              Timer(interval, keepTimerRunning);
            }
            if (snapshot.data.isNotEmpty) {
              return _buildReusableQuestionScreenBody(snapshot.data);
            }
          } else if (snapshot.hasError) {}

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  //*********************** Helper Widget Methods *************************** */

  Widget _buildReusableQuestionScreenBody(List<Question> questions) {
    var currentQuestion = questions[currentQuestionNum];

    if (this.shuffledAnswerList == null) {
      this.shuffledAnswerList = _shuffleAnswersList(
          currentQuestion.correctAnswer, currentQuestion.incorrectAnswers);
    }

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/rick_morty_background.jpg"),
                fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: 0.7,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFDFFB8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(currentQuestion.category),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFDFFB8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Text(currentQuestion.difficulty.capitalize()),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFDFFB8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'TQ: ' + questions.length.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.height / 2.7 * 1.35,
                  height: MediaQuery.of(context).size.height / 2.7,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/text_box_1.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 30, right: 30),
                      child: Text(
                        (currentQuestionNum + 1).toString() +
                            '. ' +
                            _reconstructQuestionText(currentQuestion.question),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height < 600
                              ? 15
                              : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                      //build buttons based on question type
                      child: _buildAnswersLayout(
                          shuffledAnswerList, currentQuestion.correctAnswer)),
                ),
                SizedBox(
                  height: 30,
                ),
                ResultDataDict[currentQuestionNum] != null
                    ? _buildAnswerAcknowledgment(
                        ResultDataDict[currentQuestionNum],
                        currentQuestion.correctAnswer)
                    : Text(''),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFFDFFB8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          timeToDisplay,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                IntrinsicWidth(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              "Previous Question",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              if (currentQuestionNum > 0) {
                                setState(() {
                                  this.shuffledAnswerList = null;
                                  currentQuestionNum = currentQuestionNum - 1;
                                });
                              }
                            },
                            color: Color(0xFFECA3EC),
                            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: currentQuestionNum == questions.length - 1
                                ? Text(
                                    "End Quiz",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Next Question",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                            onPressed: () {
                              if (currentQuestionNum < questions.length - 1) {
                                setState(() {
                                  this.shuffledAnswerList = null;
                                  currentQuestionNum = currentQuestionNum + 1;
                                });
                              } else {
                                //Result screen (Quiz completed)
                                _showcontent(questions.length);
                              }
                            },
                            color: Colors.blueGrey,
                            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
 *Build answers layout by shuffling answers in either true/false or multiple choice answers
 */
  Widget _buildAnswersLayout(
      List<String> shuffledAnswerLists, String correctAnswer) {
    if (shuffledAnswerLists.length == 2) {
      // Check if it is True/False question
      if (shuffledAnswerLists[0].toLowerCase() == 'false') {
        shuffledAnswerLists.insert(0, shuffledAnswerLists.removeLast());
      }

      return Column(
        //True/False question
        children: [
          _buildAnswerButton(shuffledAnswerLists[0], correctAnswer),
          _buildAnswerButton(shuffledAnswerLists[1], correctAnswer),
        ],
      );
    } else {
      //Multiple choice question
      return IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnswerButton(shuffledAnswerLists[0], correctAnswer),
            _buildAnswerButton(shuffledAnswerLists[1], correctAnswer),
            _buildAnswerButton(shuffledAnswerLists[2], correctAnswer),
            _buildAnswerButton(shuffledAnswerLists[3], correctAnswer),
          ],
        ),
      );
    }
  }

  Widget _buildAnswerButton(String answer, String correctAnswer) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.black)),
      color: ResultDataDict[currentQuestionNum] == answer
          ? Colors.yellowAccent[100]
          : null,
      child: Text(
        _reconstructQuestionText(answer),
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      onPressed: ResultDataDict[currentQuestionNum] != null
          ? () {}
          : () {
              //click, check right answer, increase totalCorrect, setState
              if (answer.toLowerCase() == correctAnswer.toLowerCase()) {
                totalCorrectAnswer = totalCorrectAnswer + 1;
              }

              setState(() {
                //need to set state since need to change button color
                ResultDataDict[currentQuestionNum] = answer;
              });
            },
    );
  }

  Widget _buildAnswerAcknowledgment(String chosenAnswer, String correctAnswer) {
    if (chosenAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
      return Center(
        child: Text(
          'Correct!\nTotal Correct Answer: ' + totalCorrectAnswer.toString(),
          style: TextStyle(
            backgroundColor: Colors.green,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Center(
        child: Text(
          'Incorrect! The correct answer is \" ' +
              _reconstructQuestionText(correctAnswer) +
              '\"',
          style: TextStyle(
            backgroundColor: Colors.red,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  //*********************** Helper Functional Methods *********************** */

  //Convert the character entity reference from html to text (using html_unescape library)
  String _reconstructQuestionText(String questionText) {
    var unescape = new HtmlUnescape();
    var text = unescape.convert(questionText);
    return text;
  }

  //Combine correct and wrong answers together and shuffle
  List<String> _shuffleAnswersList(String correctAnswer, List incorrectLists) {
    List<String> shuffledQuestionList = List<String>.from(incorrectLists);
    shuffledQuestionList.add(correctAnswer);

    var random = new Random();
    // Go through all elements.
    for (var i = shuffledQuestionList.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);
      var temp = shuffledQuestionList[i];
      shuffledQuestionList[i] = shuffledQuestionList[n];
      shuffledQuestionList[n] = temp;
    }
    return shuffledQuestionList;
  }

  void keepTimerRunning() {
    if (stopWatch.isRunning) {
      Timer(interval, keepTimerRunning);
    }

    //if mounted false, dont call set state, means widget is not part of the rendered tree
    if (mounted) {
      setState(() {
        timeToDisplay = stopWatch.elapsed.inHours.toString().padLeft(2, '0') +
            ':' +
            (stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
            ':' +
            (stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
      });
    }
  }

  void _showcontent(int totalQuestions) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          //title: new Text('You clicked on'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text(
                    'Are sure you want to end the quiz and go to scoreboard?'),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: new Text('NO'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                stopWatch.stop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return QuizCompleted(
                        totalCorrectAnswer: totalCorrectAnswer,
                        totalQuestions: totalQuestions,
                        totalTimeTaken: timeToDisplay,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
