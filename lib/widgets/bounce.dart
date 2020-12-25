import 'package:flutter/material.dart';
import 'package:notes/size_config.dart';

class Bounce extends StatefulWidget {
  final String img;

  Bounce(this.img);
  @override
  _BounceState createState() => _BounceState();
}

class _BounceState extends State<Bounce> with TickerProviderStateMixin {
  AnimationController controller;
  double _margin = 0;

  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 100,
    );

    controller.addListener(() {
      setState(() {
        _margin = controller.value;
      });
    });

    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // margin: EdgeInsets.only(left: _margin),
      child: Image(
        image: AssetImage(widget.img),
        alignment: Alignment.center,
        fit: BoxFit.cover,
        height: SizeConfig.heightMultiplier * 20,
        width: SizeConfig.widthMultiplier * 40,
      ),
    );
  }
}
