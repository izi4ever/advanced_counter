import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const _minCounter = 0;
  static const  _maxCounter = 10;
  int _incrimentSize = 1;
  String _weatherOutput = 'Press the icon to get your location';

  void _plusCounter() {
    _counter = _counter + _incrimentSize;
    if (_counter > _maxCounter) { _counter = _maxCounter; }

    setState(() {
      _counter;
    });
  }

  void _minusCounter() {
    _counter = _counter - _incrimentSize;
    if (_counter < _minCounter) { _counter = _minCounter; }

    setState(() {
      _counter;
    });
  }

  void _changeTheme() {
    if (_incrimentSize == 1) {
      _incrimentSize = 2;
    } else {
      _incrimentSize = 1;
    }

    if (_incrimentSize == 1) {
      setState(() {
        AdaptiveTheme.of(context).setLight();
      });
    } else {
      setState(() {
        AdaptiveTheme.of(context).setDark();
      });
    }
  }

  Future<void> _getWeather() async {
    // await Geolocator.openLocationSettings();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double lat = position.latitude;
    double lon = position.longitude;
    String key = 'd21d16c77f6f527f410b152eb91d24ae';
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    String? cityName = "${placemarks[0].country}, ${placemarks[0].administrativeArea}, ${placemarks[0].subAdministrativeArea}";
    WeatherFactory wf = WeatherFactory(key);

    Weather w = await wf.currentWeatherByLocation(lat, lon);
    double? celsius = w.temperature?.celsius;
    double? fahrenheit = w.temperature?.fahrenheit;

    _weatherOutput = "Weather for $cityName: ${celsius?.toStringAsFixed(1)}°C (${fahrenheit?.toStringAsFixed(1)}°F)";

    setState(() {
      _weatherOutput;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Counter'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_weatherOutput, textAlign: TextAlign.center),
            const SizedBox(height: 30),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: _getWeather,
                      tooltip: 'Get Weather',
                      child: const Icon(Icons.cloud),
                    ),
                    const Expanded(child: SizedBox()),
                    (_counter < 10) ? FloatingActionButton(
                      onPressed: _plusCounter,
                      tooltip: 'Increment',
                      child: const Icon(Icons.add),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: _changeTheme,
                      tooltip: 'Change Theme',
                      child: const Icon(Icons.palette),
                    ),
                    const Expanded(child: SizedBox()),
                    (_counter > 0) ? FloatingActionButton(
                      onPressed: _minusCounter,
                      tooltip: 'Minus',
                      child: const Icon(Icons.remove),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
