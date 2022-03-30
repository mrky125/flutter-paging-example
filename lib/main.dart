import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _InfinityScrollPage(),
    );
  }
}

class _InfinityScrollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              child: Text(
                index.toString(),
                style: const TextStyle(fontSize: 20.0),
              ),
              padding: const EdgeInsets.all(20.0),
            ),
          );
        },
      ),
    );
  }
}
