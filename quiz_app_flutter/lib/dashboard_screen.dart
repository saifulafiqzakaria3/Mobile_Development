import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dashboard_setup_utility.dart';
import 'question.dart';
import 'question_screen.dart';

class QuizDashboard extends StatefulWidget {
  @override
  _QuizDashboardState createState() => _QuizDashboardState();
}

class _QuizDashboardState extends State<QuizDashboard> {
  num _questionNumber;
  QuestionCategory _chosenCategory;
  String _difficulty = 'Any Difficulty';
  String _questionType = 'Any Type';

  Future<List<QuestionCategory>> futureCategories;

  final String baseApiUrl = 'https://opentdb.com/api.php?';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //To avoid the screen from resizing when keyboard appear
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: FutureBuilder<List<QuestionCategory>>(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (_chosenCategory == null) {
                _chosenCategory = snapshot.data[0];
              }
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber, //Color(0xFFFDFFB8),
                      image: DecorationImage(
                        image: AssetImage("images/dashboard_bg.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 50, top: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width * 0.7,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/quiz_time_1.png"),
                                    fit: BoxFit.fitWidth),
                              ),
                            ),
                            _buildTextLabel(
                              "Number of Questions:",
                              20,
                              FontWeight.bold,
                            ),
                            _buildQuestionNumberTextField(),
                            SizedBox(height: 20),
                            _buildTextLabel(
                              "Category: ",
                              20,
                              FontWeight.bold,
                            ),
                            _buildCategoriesDropdownMenu(
                                _chosenCategory,
                                snapshot.data,
                                _quizCategoryDropDownValueChanged),
                            SizedBox(height: 20),
                            _buildTextLabel(
                              "Difficulty: ",
                              20,
                              FontWeight.bold,
                            ),
                            _buildCustomDropdownMenu(
                                _difficulty,
                                ['Any Difficulty', 'Easy', 'Medium', 'Hard'],
                                _difficultyDropDownValueChanged),
                            SizedBox(height: 20),
                            _buildTextLabel(
                              "Question Type: ",
                              20,
                              FontWeight.bold,
                            ),
                            _buildCustomDropdownMenu(
                                _questionType,
                                ['Any Type', 'Multiple Choice', 'True/False'],
                                _questionTypeDropDownValueChanged),
                            SizedBox(height: 30),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.black)),
                              onPressed: _startButtonClicked,
                              child: Text("Start Quiz",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white)),
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {}

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  void _startButtonClicked() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    String apiUrl = baseApiUrl;

    //convert the dropdown value to APIUrl
    apiUrl = apiUrl + 'amount=' + _questionNumber.toString();
    if (_chosenCategory.id != 0) {
      apiUrl = apiUrl + '&category=' + _chosenCategory.id.toString();
    }

    if (_difficulty != 'Any Difficulty') {
      apiUrl = apiUrl + '&difficulty=' + _difficulty.toLowerCase();
    }

    if (_questionType != 'Any Type') {
      if (_questionType == 'Multiple Choice') {
        apiUrl = apiUrl + '&type=multiple';
      } else if (_questionType == 'True/False') {
        apiUrl = apiUrl + '&type=boolean';
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return QuestionScreen(
            apiUrl: apiUrl,
          );
        },
      ),
    );
  }

  void _quizCategoryDropDownValueChanged(QuestionCategory newCategory) {
    setState(() {
      _chosenCategory = newCategory;
    });
  }

  void _difficultyDropDownValueChanged(String newValue) {
    setState(() {
      _difficulty = newValue;
    });
  }

  void _questionTypeDropDownValueChanged(String newValue) {
    setState(() {
      _questionType = newValue;
    });
  }

  Widget _buildCustomDropdownMenu(
      String currentValue, List choices, Function onChanged) {
    return QuizSetupDropdownButton(
        dropdownCurrentValue: currentValue,
        options: choices,
        onChanged: onChanged);
  }

  Widget _buildCategoriesDropdownMenu(QuestionCategory currentValue,
      List<QuestionCategory> choices, Function onChanged) {
    return CategoryDropdownButton(
        dropdownCurrentValue: currentValue,
        categories: choices,
        onChanged: onChanged);
  }

  Widget _buildTextLabel(
      String titleLabel, double fontsize, FontWeight fontWeight) {
    return Text(
      titleLabel,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontsize),
    );
  }

  Widget _buildQuestionNumberTextField() {
    return TextFormField(
      initialValue: '10',
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return "Number of Questions is Required";
        } else if (num.tryParse(value) == null) {
          return "Please Input a Number";
        } else if (num.tryParse(value) > 50) {
          return "Questions Cannot be More Than 50";
        } else if (num.tryParse(value) <= 0) {
          return "Questions Cannot be Less Than 1";
        }
      },
      onSaved: (String value) {
        _questionNumber = num.tryParse(value);
      },
    );
  }
}
