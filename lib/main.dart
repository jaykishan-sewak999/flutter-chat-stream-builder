import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Message {
  final String sender;
  final String message;

  Message(this.sender, this.message);
}

class MessageBlock {
  final _streamController = StreamController<Message>.broadcast();

  Stream<Message> get messageStream => _streamController.stream;

  void startChat() {
    final fake = Faker();
    _streamController.add(Message(fake.person.name(), fake.lorem.sentence()));
  }

  void dispose() {
    _streamController.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final MessageBlock _counterBlock = MessageBlock();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _counterBlock.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<Message>(
            stream: _counterBlock.messageStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  "Error: ${snapshot.error}",
                );
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No data"),);
              } else {
                return ListTile(
                  title: Text(snapshot.data!.sender),
                  subtitle: Text(snapshot.data!.message),
                );
              }
            },
          ),
        ),
        ElevatedButton(
            onPressed: () {
              _counterBlock.startChat();
            },
            child: const Text("Send message"))
      ],
    );
  }
}
