import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:healthapp/util/dialogs/error_dialog.dart';
import 'package:healthapp/util/weatherInformation.dart';
import 'package:healthapp/weekly_weather/weekly_weather_card.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';
import 'package:healthapp/bloc/caffeine_detailed_bloc.dart';

import '../backend/location/location.dart';
import '../backend/weather/weather.dart';

class WeatherDetailedView extends StatefulWidget {
  const WeatherDetailedView({super.key});

  @override
  State<WeatherDetailedView> createState() => _WeatherDetailedViewState();
}

class _WeatherDetailedViewState extends State<WeatherDetailedView> {
  Future<Location> fetchLocation() async {
    return await Location.create();
  }

  Future<List<WeatherInformationWeekly>> fetchWeatherData(
      Position position) async {
    ApiParser apiParser = ApiParser();
    List<WeatherInformationWeekly> wi = await apiParser.requestWeeklyWeather(
        position.latitude, position.longitude);
    return wi;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchLocation(),
        builder: (context, AsyncSnapshot<Location> location) {
          if (location.hasData) {
            return Container(
                child:
                    ListView(physics: BouncingScrollPhysics(), children: [
                      Column(
                        children: [
                          generateWeatherCards(location.data!.position)
                        ],
                      )
                    ]));
          }else{
            return Container(color: Colors.white, child: const Center(child: CircularProgressIndicator()));
          }
        });
  }

  
  
  generateWeatherCards(Position position) async {
    List<WeatherInformationWeekly> wi = await fetchWeatherData(position);
    WeeklyWeatherCard(wi[0]);
  }
}
