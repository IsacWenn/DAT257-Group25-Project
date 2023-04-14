import 'dart:collection';
import 'dart:convert';

import 'package:healthapp/util/weatherInformation.dart';
import 'package:healthapp/util/weatherType.dart';

class JsonParser{
  late HourlyWeatherCollection hwc;
  HashMap weatherTypeMap = HashMap<int, WeatherType>();

  JsonParser(String weatherJson){
    initWeatherTypes();
    initHwc(weatherJson);
  }

  // adds the different weather codes to a map which we can use to extract an enum
  void initWeatherTypes(){
    weatherTypeMap[0] = WeatherType.clear; // clear sky
    weatherTypeMap[1] = WeatherType.halfCloudy; // mainly clear
    weatherTypeMap[2] = WeatherType.halfCloudy; // partly cloudy
    weatherTypeMap[3] = WeatherType.cloudy; // overcast
    weatherTypeMap[45] = WeatherType.foggy; // fog
    weatherTypeMap[48] = WeatherType.foggy; // depositing rime fog
    weatherTypeMap[51] = WeatherType.raining; // light drizzle
    weatherTypeMap[53] = WeatherType.raining; // moderate drizzle
    weatherTypeMap[55] = WeatherType.raining; // dense drizzle
    weatherTypeMap[56] = WeatherType.raining; // light freezing drizzle
    weatherTypeMap[57] = WeatherType.raining; // dense freezing drizzle
    weatherTypeMap[61] = WeatherType.raining; // light rain
    weatherTypeMap[63] = WeatherType.raining; // moderate rain
    weatherTypeMap[65] = WeatherType.raining; // heavy rain
    weatherTypeMap[66] = WeatherType.raining; // light freezing rain
    weatherTypeMap[67] = WeatherType.raining; // heavy freezing rain
    weatherTypeMap[71] = WeatherType.snowing; // slight snow fall
    weatherTypeMap[73] = WeatherType.snowing; // moderate snow fall
    weatherTypeMap[75] = WeatherType.snowing; // heavy snow fall
    weatherTypeMap[77] = WeatherType.snowing; // snow grains
    weatherTypeMap[80] = WeatherType.raining; // slight rain showers
    weatherTypeMap[81] = WeatherType.raining; // moderate rain showers
    weatherTypeMap[82] = WeatherType.raining; // violent rain showers
    weatherTypeMap[85] = WeatherType.snowing; // slight snow showers
    weatherTypeMap[86] = WeatherType.snowing; // heavy snow showers
  }

  // uses string manipulation and Json parsing to get an object that contains the relevant
  // parts of the result of our api request concerning the weather
  void initHwc(String weatherJson){
      List<String> hourlyList = weatherJson.split("hourly");
      String hourlyString = hourlyList[2].substring(2, hourlyList[2].length - 1);
      Map<String, dynamic> valuemap = json.decode(hourlyString);
      this.hwc = HourlyWeatherCollection.fromJson(valuemap);
  }

  // turns our one large hourly weather object into a list of weather objects each representing
  // one hour that can be used by the front end
  List<WeatherInformation> jsonDataConverter(){
    List<WeatherInformation> weatherInformation = [];

    for( int i = 0 ; i < hwc.time.length ; i++ ){
      WeatherType wt = weatherTypeMap[hwc.weathercode[i]];
      WeatherInformation wi = WeatherInformation(hwc.time[i], hwc.temperature_2m[i], hwc.precipitation[i], 
      hwc.snowfall[i], hwc.snow_depth[i], wt, hwc.cloudcover[i], hwc.windspeed_10m[i],
      hwc.winddirection_10m[i]);
      weatherInformation.add(wi);
    }
    return weatherInformation;
  }
}

// A class contaiing the results of our api request over the entire week representing each attribute
// as a list
class HourlyWeatherCollection {
  HourlyWeatherCollection({required this.time, required this.temperature_2m, required this.precipitation, 
  required this.snowfall, required this.snow_depth, required this.weathercode, required this.cloudcover,
  required this.windspeed_10m, required this.winddirection_10m});
  List<String> time;  
  List<double> temperature_2m;
  List<double> precipitation;
  List<double> snowfall;
  List<double> snow_depth;
  List<int> weathercode;
  List<int> cloudcover;
  List<double> windspeed_10m;
  List<int> winddirection_10m;

  // factory method that allows us to parse json into object of this type
  factory HourlyWeatherCollection.fromJson(Map <String, dynamic> data){
    final time = data['time'].cast<String>() as List<String>; 
    final temperature_2m = data['temperature_2m'].cast<double>() as List<double>; 
    final precipitation = data['precipitation'].cast<double>() as List<double>;
    final snowfall = data['snowfall'].cast<double>() as List<double>;
    final snow_depth = data['snow_depth'].cast<double>() as List<double>;
    final weathercode = data['weathercode'].cast<int>() as List<int>;
    final cloudcover = data['cloudcover'].cast<int>() as List<int>;
    final windspeed_10m = data['windspeed_10m'].cast<double>() as List<double>;
    final winddirection_10m = data['winddirection_10m'].cast<int>() as List<int>;
    return HourlyWeatherCollection(time: time, temperature_2m: temperature_2m, 
    precipitation: precipitation, snowfall: snowfall, snow_depth: snow_depth, 
    weathercode: weathercode, cloudcover: cloudcover, 
    windspeed_10m: windspeed_10m, winddirection_10m: winddirection_10m);
  }

}



