import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/question.dart';

class QuizCompleted extends StatefulWidget {
  final int totalCorrectAnswer;
  final int totalQuestions;
  final String totalTimeTaken;
  QuizCompleted({
    Key key,
    @required this.totalCorrectAnswer,
    @required this.totalQuestions,
    @required this.totalTimeTaken,
  }) : super(key: key);

  @override
  _QuizCompletedState createState() => _QuizCompletedState();
}

class _QuizCompletedState extends State<QuizCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.amber, //Color(0xFFFDFFB8),
              image: DecorationImage(
                  image: AssetImage("images/shinchan_cheek.png"),
                  fit: BoxFit.fill),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/game_over.png"),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFFDFFB8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            _buildRowForResultAnalysis(
                                'Total Correct Answer',
                                widget.totalCorrectAnswer.toString() +
                                    '/' +
                                    widget.totalQuestions.toString()),
                            Text(
                              '----------------------',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            ),
                            _buildRowForResultAnalysis(
                                'Total Score (%)',
                                (widget.totalCorrectAnswer /
                                        widget.totalQuestions *
                                        100)
                                    .toStringAsFixed(1)),
                            Text(
                              '----------------------',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            ),
                            _buildRowForResultAnalysis(
                                'Total Time', widget.totalTimeTaken),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    child: Text(
                      'Try Another Quiz',
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowForResultAnalysis(String leftLabel, String rightLabel) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            leftLabel,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            rightLabel,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        )
      ],
    );
  }
}
