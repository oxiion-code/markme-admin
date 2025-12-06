import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget{
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child:SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset("assets/animations/loading.json"),
      ),
    );
  }
}