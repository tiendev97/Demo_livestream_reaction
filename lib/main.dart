import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/reaction_container.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BehaviorSubject<List<String>> reactions =
      BehaviorSubject<List<String>>.seeded([]);
  Stream<List<String>> get reactionSteam => reactions.stream;
  List<String> urlImages = [];

  void addNewReaction(String urlImage) {
    if (urlImages.length < 30) {
      urlImages.add(urlImage);
      reactions.sink.add(urlImages);
    }
  }

  void onAnimationEnded(index) {
    if (index == 30) {
      reactions.sink.add([]);
      urlImages = [];
    } else {
      urlImages.remove(index);
    }
  }

  @override
  void dispose() {
    reactions.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              right: 12,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ReactionContainer(
                  reactionStream: reactionSteam,
                  onAnimationEnded: onAnimationEnded,
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => handleSendReaction('assets/images/happy.png'),
                    child: Image.asset(
                      'assets/images/happy.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () =>
                        handleSendReaction('assets/images/surprised.png'),
                    child: Image.asset(
                      'assets/images/surprised.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => handleSendReaction('assets/images/sad.png'),
                    child: Image.asset(
                      'assets/images/sad.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => handleSendReaction('assets/images/angry.png'),
                    child: Image.asset(
                      'assets/images/angry.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleSendReaction(String icon) {
    addNewReaction(icon);
  }
}
