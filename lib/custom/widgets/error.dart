import 'package:flutter/material.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';

class Error extends StatelessWidget {
  final Function reload;
  final NException error;
  const Error({Key key, @required this.reload, @required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error.message,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical,
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
