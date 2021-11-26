import 'package:dots_indicator/dot_indicator_painter.dart';
import 'package:flutter/material.dart';

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
        ),
        home: DotExamplePage());
  }
}

class DotExamplePage extends StatefulWidget {
  DotExamplePage({Key? key}) : super(key: key);

  @override
  _DotExamplePageState createState() => _DotExamplePageState();
}

class _DotExamplePageState extends State<DotExamplePage> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  double _offset = 0.0;

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        6,
        (index) => Container(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Container(
                height: 280,
                child: Center(child: Text("Page $index")),
              ),
            ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('$_offset'),
            Slider(
                value: _offset,
                min: -7.0,
                max: 7.0,
                onChanged: (newValue) {
                  setState(() {
                    _offset = newValue;
                  });
                }),
            BcDotIndicator(offset: _offset),
          ],
        ),
      ),
    );
  }
}

class BcDotIndicator extends StatefulWidget {
  const BcDotIndicator({
    Key? key,
    required double offset,
  })  : _offset = offset,
        super(key: key);

  final double _offset;

  @override
  _BcDotIndicatorState createState() => _BcDotIndicatorState();
}

class _BcDotIndicatorState extends State<BcDotIndicator> {
  int currentIndex = 0;
  double? offsetState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // offsetState = widget._offset;
    // if (widget._offset.abs() == 1) {
    currentIndex += widget._offset.round();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      width: 250,
      height: 20,
      child: CustomPaint(
        painter: DotIndicatorPainter(Offset(widget._offset, 0), currentIndex),
      ),
    );
  }
}
