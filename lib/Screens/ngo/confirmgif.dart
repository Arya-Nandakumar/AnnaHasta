import 'package:annahasta/Screens/ngo/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class Donategif extends StatefulWidget {
  

  @override
  State<Donategif> createState() => _MyAppState();
}

class _MyAppState extends State<Donategif> with TickerProviderStateMixin {
  late final AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
   _controller = AnimationController(vsync: this);
//     _controller.addListener(() {
//       print(_controller.value);
//     //  if the full duration of the animation is 8 secs then 0.5 is 4 secs
//       if (_controller.value > 0.5) {
// // When it gets there hold it there.
//         _controller.value = 0.5;
//       }
//     });

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Navigator.pop(context);
        // _controller.reset();
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
        Padding(
           padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/donategif.json',
                      repeat: false,
                      fit: BoxFit.fill,
                      controller: _controller,
                      onLoaded: (composition) {
                        // Configure the AnimationController with the duration of the
                        // Lottie file and start the animation.
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                    Text(
  'Thank You!\nBecause of You there is one less empty stomach :)',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Sedgwick Ave Display',
    fontSize: 40,
    color: Colors.purple[100],
    letterSpacing: .5,
  ),
),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  }
}