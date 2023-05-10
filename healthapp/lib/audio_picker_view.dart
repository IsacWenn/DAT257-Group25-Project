import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/breathing_view.dart';
import 'package:healthapp/dashboard/gradientColor.dart';

import 'bloc/breathing_bloc.dart';

const List<List<String>> audioList = [
  ['Breathing', 'assets/images/breathing.png'],
  ['Meditation', 'assets/images/meditation.png'],
  ['Sleep', 'assets/images/sleep.png'],
  ['Focus', 'assets/images/relax.png'],
];

class AudioPickerView extends StatelessWidget {
  List<List<String>> audioCards = audioList;
  AudioPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB6CFFA),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: GradientColor.getGradient(Color(0xFFA6CFFA).value),
            begin: Alignment.topLeft,
            end: Alignment.center,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AudioCard(
                    title: audioCards[0].first, imageUrl: audioCards[0].last),
                AudioCard(
                    title: audioCards[1].first, imageUrl: audioCards[1].last)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AudioCard(
                    title: audioCards[2].first, imageUrl: audioCards[2].last),
                AudioCard(
                    title: audioCards[3].first, imageUrl: audioCards[3].last)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AudioCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const AudioCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage("assets/images/raining.png"),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.all(10),
      width: 180,
      height: 250,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => BreathingBloc()
                  ..add(FetchBreathingExercise(category: title)),
                child: AudioView(),
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
