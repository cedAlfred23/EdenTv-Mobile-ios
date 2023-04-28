import 'package:flutter/material.dart';
import 'package:eden/utils/constante.dart';

class CommentaireLigne extends StatelessWidget {
  const CommentaireLigne(
      {Key? key,
      required this.username,
      required this.message,
      required this.date})
      : super(key: key);
  final String username;
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                // color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            child: const Icon(Icons.account_circle_outlined),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: typeRadioStyle,
              ),
              const SizedBox(height: 4.0),
              Text(
                message,
                style: typeRadioStyle,
              ),
              const SizedBox(height: 4.0),
              Text(
                date,
                style: typeRadioStyle,
              ),
              const SizedBox(height: 4.0),
            ],
          )
        ],
      ),
    );
  }
}
