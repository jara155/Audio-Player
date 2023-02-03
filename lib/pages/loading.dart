import 'package:audioplayer/pages/home.dart';
import 'package:audioplayer/utils/keys.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../utils/colors.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  load() async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(context, PageTransition(
        type: PageTransitionType.bottomToTop,
        alignment: Alignment.center,
        child: Home(key: homeKey,)
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: primary,
      size: 100,
    );
  }
}
