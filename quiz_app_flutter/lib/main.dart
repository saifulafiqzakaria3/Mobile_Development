import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

/*
  Guidelines: 
1) Use the questions and answers from https://opentdb.com
2) As a user, I should be able to launch the app and see a Start Quiz page, 
    for which I should be able to set number of questions, category, 
    difficulty and question type before clicking on the Start Quiz button.
    https://youtu.be/rVKQsKIqgx4
3) The quiz questions/answers will be retrieved from OpenTDB via API call 
    based on the settings set above.
4) As a quiz participant, I'm playing against the clock, and the app should 
    track how long I take to complete the quiz.
    https://youtu.be/yHrpx4PoBzU
5) As a quiz participant, each question will let me know whether the choice 
    I make is correct or not.
    https://youtu.be/90w7giIMs8M
6) At the end of each quiz attempt, I get to see my total score
7) As a quiz participant, I want to see a list (a score board) containing all 
    my completed quiz attempts with the following details: Date/Time, Duration, 
    Correct Answers/Number of Questions Answered.

  Other Technical Requirements:
  - Store score board information on device and data must persist.
  - Ensure your code is checked into your repo on Git2. Do not host 
    it externally.

  Extra:
  - Use of 3rd party libraries
  - Proper use of application lifecycle methods

  API https://opentdb.com : 
  eg: https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple
  eg: https://opentdb.com/api.php?amount=10
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizDashboard(), //Dashboard(),
    );
  }
}
