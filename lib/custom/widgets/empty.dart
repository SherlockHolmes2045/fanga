import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final Function reload;
  const Empty({Key key, @required this.reload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Une erreur est survenue.",
            style: TextStyle(color: Colors.white),
          ),
          RaisedButton(
            onPressed: reload,
            child: Text("Réessayer"),
          )
        ],
      ),
    );
  }
}
