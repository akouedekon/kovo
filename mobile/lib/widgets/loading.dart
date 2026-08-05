import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String? message;
  const Loading({super.key, this.message});
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), if (message!=null) SizedBox(height:8), if (message!=null) Text(message!)]));
  }
}
