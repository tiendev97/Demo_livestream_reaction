import 'package:flutter/material.dart';
import 'package:flutter_app/reaction_animation_item.dart';

class ReactionContainer extends StatefulWidget {
  final Stream<List<String>> reactionStream;
  final Function(int) onAnimationEnded;

  const ReactionContainer({
    Key key,
    this.reactionStream,
    this.onAnimationEnded,
  }) : super(key: key);

  @override
  _ReactionContainerState createState() => _ReactionContainerState();
}

class _ReactionContainerState extends State<ReactionContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.4;
    final height = MediaQuery.of(context).size.height * 0.5;

    return StreamBuilder(
      stream: widget.reactionStream,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) return SizedBox();

        List<String> urls = snapshot.data;
        List<Widget> reactionWidgets = [];
        for (var i = 0; i < urls.length; i++) {
          reactionWidgets.add(
            ReactionAnimationItem(
              width: width,
              height: height,
              index: i + 1,
              icon: urls[i],
              animationEnded: widget.onAnimationEnded,
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: reactionWidgets,
        );
      },
    );
  }
}
