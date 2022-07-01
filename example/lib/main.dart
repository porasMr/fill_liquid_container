import 'package:flutter/material.dart';
import 'package:fill_liquid_container/fill_liquid_container.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        child: ContainerLiquidFill(
          boxHeight: MediaQuery.of(context).size.height - 40,
          boxWidth: MediaQuery.of(context).size.width,
          boxBackgroundColor: Colors.white,
          image: "",
          waveColor: Colors.green,
        ),
      ),
    );
  }
}
