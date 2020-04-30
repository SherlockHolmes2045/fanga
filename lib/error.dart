import 'package:flutter/material.dart';

class Error extends StatelessWidget {

  final String errorMessage;



  final Function onRetryPressed;



  const Error({Key key, this.errorMessage, this.onRetryPressed})

      : super(key: key);



  @override

  Widget build(BuildContext context) {

    return Center(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[

          Text(

            errorMessage,

            textAlign: TextAlign.center,

            style: TextStyle(

              color: Colors.white,

              fontSize: 18,

            ),

          ),

          SizedBox(height: 8),

          RaisedButton(

            color: Colors.grey,

            child: Text('Retry', style: TextStyle(color: Colors.black)),

            onPressed: onRetryPressed,

    )

    ],

    ),

    );
    }

  }

