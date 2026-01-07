import 'package:flutter/material.dart';

class Homelarge extends StatelessWidget {
  const Homelarge({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 7,
                child: Container(
                  child: Center(child: Text('좌측 글씨')),
                  color: Colors.red
                )
            ),
            Expanded(
              flex: 3,
                child: Container(
                  child: Center(child: Text('우측 글씨')),
                  color: Colors.pinkAccent
                )
            )
          ],
        )
    );
  }
}
