import 'package:flutter/material.dart';

class TitleRow extends StatelessWidget {
  const TitleRow({
    Key? key,
    required this.firstTitle,
    required this.secondTitle
  }): super(key: key);
  final String firstTitle;
  final String secondTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.green[300],
            child: ListTile(
              title: Text(firstTitle),
            ),
          ),
        ),
        const VerticalDivider(
          color: Colors.blue,
          width: 1,
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.green[300],
            child: ListTile(
              title: Text(secondTitle),
            ),
          ),
        ),
      ],
    );
  }
}
