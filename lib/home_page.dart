import 'package:flutter/material.dart';
import 'package:flutter_animation_show_item/price_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showInputTabOptions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40.0),
              child: new Column(
                children: <Widget>[
                  Expanded(
                      child: PriceTab(
                    height: MediaQuery.of(context).size.height - 48.0,
                    onPlaneFlightStart: () =>
                        setState(() => showInputTabOptions = false),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
