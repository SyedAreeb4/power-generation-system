import 'package:flutter/material.dart';

import 'hydro.dart';
import 'steam.dart';
import 'load.dart';
import 'solar.dart';
import 'wind.dart';
import 'nuclear.dart';
import 'geothermal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      routes: {
        '/hydro': (context) => HydroScreen(),
        '/steam': (context) => SteamScreen(),
        '/load': (context) => LoadScreen(),
        '/solar': (context) => SolarScreen(),
        '/wind': (context) => WindScreen(),
        '/nuclear': (context) => NuclearScreen(),
        '/geothermal': (context) => GeothermalScreen(),
      },
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 20, 71, 180),
        scaffoldBackgroundColor: Color.fromARGB(255, 35, 178, 245),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  Widget buildNavigationButton(
      BuildContext context, String label, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POWER GENERATION SYSTEM',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildImageCard(
                  context, 'STEAM POWER PLANT', '/steam', 1, screenHeight),
              buildImageCard(
                  context, 'HYDRO POWER PLANT', '/hydro', 0, screenHeight),
              buildImageCard(
                  context, 'SOLAR POWER PLANT', '/solar', 3, screenHeight),
              buildImageCard(
                  context, 'WIND POWER PLANT', '/wind', 4, screenHeight),
              buildImageCard(
                  context, 'NUCLEAR POWER PLANT', '/nuclear', 5, screenHeight),
              buildImageCard(context, 'GEOTHERMAL POWER PLANT', '/geothermal',
                  6, screenHeight),
              buildImageCard(context, 'TECHNICAL ANALYSIS (Load Profile)',
                  '/load', 2, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageCard(BuildContext context, String label, String route,
      int index, double screenHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image${index + 1}.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: screenHeight * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
