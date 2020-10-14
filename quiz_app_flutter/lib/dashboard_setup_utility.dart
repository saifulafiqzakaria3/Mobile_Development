import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/question.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<QuestionCategory>> fetchCategories() async {
  List<QuestionCategory> categories;
  //get all categories and their ids
  final response = await http.get('https://opentdb.com/api_category.php');
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var results = data['trivia_categories'] as List;
    categories = results
        .map<QuestionCategory>((json) => QuestionCategory.fromJson(json))
        .toList();
    categories.insert(0, QuestionCategory(id: 0, name: 'Any Category'));
    return categories;
  } else {
    // throw an exception if error.
    throw Exception('Failed to load categories');
  }
}

class QuizSetupDropdownButton extends StatelessWidget {
  QuizSetupDropdownButton(
      {Key key,
      this.dropdownCurrentValue,
      this.options,
      @required this.onChanged})
      : super(key: key);

  final String dropdownCurrentValue;
  final List options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
            color: Colors.indigo, style: BorderStyle.solid, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButton<String>(
        isExpanded: true, //Bring the arrow icon to the end of the container
        hint: Text('Any'),
        value: dropdownCurrentValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.black26,
        ),
        onChanged: (String newValue) {
          onChanged(newValue);
        },
        items: options.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryDropdownButton extends StatelessWidget {
  CategoryDropdownButton(
      {Key key,
      this.dropdownCurrentValue,
      this.categories,
      @required this.onChanged})
      : super(key: key);

  final QuestionCategory dropdownCurrentValue;
  final List<QuestionCategory> categories;
  final ValueChanged<QuestionCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
            color: Colors.indigo, style: BorderStyle.solid, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButton<QuestionCategory>(
        isExpanded: true, //Bring the arrow icon to the end of the container
        hint: Text('Any'),
        value: dropdownCurrentValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.black26,
        ),
        onChanged: (QuestionCategory newValue) {
          onChanged(newValue);
        },
        items: categories.map((choice) {
          return DropdownMenuItem<QuestionCategory>(
            value: choice,
            child: Text(choice.name),
          );
        }).toList(),
      ),
    );
  }
}
