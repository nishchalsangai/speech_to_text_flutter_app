import 'package:flutter/material.dart';

Widget passwordCheckIndicator(double strength) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    height: 5,
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: LinearProgressIndicator(
        value: strength,
        backgroundColor: Colors.grey[100],
        color: strength <= 1 / 3
            ? Colors.red
            : strength == 2 / 3
                ? Colors.yellow
                : Colors.green,
        minHeight: 5,
      ),
    ),
  );
}
