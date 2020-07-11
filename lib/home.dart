import 'package:albumapp/colors.dart';
import 'package:flutter/material.dart';

class Content{
  // image
  // text
}

class HomePage extends StatelessWidget {

  //final List<Content> _titles = Content.titles;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        color: kLightGreen,
        child: ListView(
          children: _titles
            .map((Content c) => _buildContent(c, context))
            .toList()),
          ),
        );
      } 
    }

Widget _buildContent(Content category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      //onTap: () => onCategoryTap(category),
      child: // ListView
    );
  }