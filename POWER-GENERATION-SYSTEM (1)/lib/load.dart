import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _loadControllers =
      List.generate(24, (_) => TextEditingController());
  List<FlSpot> _spots = [];
  List<BarChartGroupData> _barGroups = [];
  // final _plantCapacityController = TextEditingController();
  double _loadFactor = 0;
  double _totalKWH = 0;
  double _peakDemand = 0;
  double _averageLoad = 0;
  double _plantCapacityMW = 0;
  double _plantCapacityFactor = 0;
  double _annualEnergyKWh = 0;

  @override
  void dispose() {
    for (var controller in _loadControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void generateLoadDurationCurve() {
    List<double> loadData = [];
    List<double> originalLoadData = [];
    double totalLoad = 0;
    double peakLoad = 0;
    // final plantCapacity = double.tryParse(_plantCapacityController.text) ?? 0;

    for (int i = 0; i < 24; i++) {
      double load = double.tryParse(_loadControllers[i].text) ?? 0;
      loadData.add(load);
      originalLoadData.add(load);
      totalLoad += load;
      if (load > peakLoad) {
        peakLoad = load;
      }
    }

    loadData.sort((a, b) => b.compareTo(a)); // Sort by load in descending order

    setState(() {
      _spots = loadData.asMap().entries.map((entry) {
        int idx = entry.key;
        double value = entry.value;
        return FlSpot(idx.toDouble(), value);
      }).toList();

      _barGroups = originalLoadData.asMap().entries.map((entry) {
        int idx = entry.key;
        double value = entry.value;
        return BarChartGroupData(
          x: idx,
          barRods: [
            BarChartRodData(
              toY: value,
              color: Colors.blue,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }).toList();

      // Calculate metrics
      double totalHours = 24;
      double energyPerDayKWh = totalLoad;
      double averageLoad = totalLoad / totalHours;
      double loadFactor = averageLoad / peakLoad;
      double plantCapacityMW = peakLoad * 1.15; // Assuming a factor of 1.25
      double plantCapacityFactor = totalLoad / (plantCapacityMW * totalHours);
      double annualEnergyKWh = energyPerDayKWh * 365;

      // Update state variables
      _loadFactor = loadFactor;
      _totalKWH = energyPerDayKWh;
      _peakDemand = peakLoad;
      _averageLoad = averageLoad;
      _plantCapacityMW = plantCapacityMW;
      _plantCapacityFactor = plantCapacityFactor;
      _annualEnergyKWh = annualEnergyKWh;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 71, 180),
        title: Text('TECHNICAL ANALYSIS', style: TextStyle(fontSize: 20)),
      ),
      backgroundColor: Color.fromARGB(255, 35, 178, 245),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 500, // Adjust height as needed
                  child: ListView.builder(
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      return buildLoadField(index);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: generateLoadDurationCurve,
                  child: Text('Generate Load Profile Graph and Duration Curve'),
                ),
                SizedBox(height: 20),
                if (_barGroups.isNotEmpty)
                  Container(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        barGroups: _barGroups,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 2 == 0) {
                                  // Display every 2nd hour
                                  return Text('${value.toInt()}h');
                                }
                                return Container();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                if (value % 10 == 0) {
                                  // Display every 10 kW
                                  return Text('${value.toInt()}kW');
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                if (_spots.isNotEmpty)
                  Container(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: _spots,
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 2 == 0) {
                                  // Display every 2nd hour
                                  return Text('${value.toInt()}h');
                                }
                                return Container();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                if (value % 10 == 0) {
                                  // Display every 10 kW
                                  return Text('${value.toInt()}kW');
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                // buildTextField('Plant Capacity', _plantCapacityController),
                Text('Load Factor: ${_loadFactor.toStringAsFixed(2)}%'),
                Text('Total KWH: ${_totalKWH.toStringAsFixed(2)}'),
                Text('Peak Demand: ${_peakDemand.toStringAsFixed(2)} kW'),
                Text('Average Load: ${_averageLoad.toStringAsFixed(2)} kW'),
                Text(
                    'Plant Capacity : ${_plantCapacityMW.toStringAsFixed(2)} KW'),
                Text(
                    'Plant Capacity Factor: ${_plantCapacityFactor.toStringAsFixed(2)}'),
                Text(
                    'Annual Energy KWh: ${_annualEnergyKWh.toStringAsFixed(2)} KWh'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoadField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _loadControllers[index],
        decoration: InputDecoration(
          labelText: 'Hour ${index + 1} Load',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
