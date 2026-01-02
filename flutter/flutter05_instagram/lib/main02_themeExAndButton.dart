import 'package:flutter/material.dart';
import 'package:flutter05_instagram/style.dart';
import './style2.dart' as style;

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.add_box_outlined)
            )
          ],
      ),
      body: Column(
        children: [
          Text('도구는 생각하지 마라'),
          Text('All Extinction', style: Theme.of(context).textTheme.bodyLarge),
          TextButton(onPressed: (){}, child: Text('Text Button')),
          ElevatedButton(onPressed: (){}, child: Text('Elevated Button')),
        ],
      )
    );
  }
}


