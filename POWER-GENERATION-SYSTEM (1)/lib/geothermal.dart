import 'package:flutter/material.dart';

class GeothermalScreen extends StatefulWidget {
  @override
  _GeothermalScreenState createState() => _GeothermalScreenState();
}

class _GeothermalScreenState extends State<GeothermalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _constructionCostController = TextEditingController();
  final _interestDepController = TextEditingController();
  final _operatingCostController = TextEditingController();
  final _maintenanceCostController = TextEditingController();
  final _annualEnergyController = TextEditingController();

  double fixedCost = 0;
  double variableCost = 0;
  double costPerUnit = 0;
  double costpkr = 0;

  void calculateGeothermalCost() {
    final constructionCost =
        double.tryParse(_constructionCostController.text) ?? 0;
    final interestDep = double.tryParse(_interestDepController.text) ?? 0;
    final operatingCost = double.tryParse(_operatingCostController.text) ?? 0;
    final maintenanceCost =
        double.tryParse(_maintenanceCostController.text) ?? 0;
    final annualEnergy = double.tryParse(_annualEnergyController.text) ?? 0;

    setState(() {
      fixedCost = (constructionCost * (interestDep / 100));
      variableCost = (maintenanceCost + operatingCost);
      costPerUnit = ((fixedCost + variableCost) / annualEnergy);
      costpkr = costPerUnit * 285;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 139, 69, 19),
        title: Text('GEOTHERMAL POWER PLANT', style: TextStyle(fontSize: 20)),
      ),
      backgroundColor: Color.fromARGB(255, 244, 164, 96),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(
                  'Construction Cost (\$)', _constructionCostController),
              buildTextField(
                  'Interest and Depreciation (%)', _interestDepController),
              buildTextField('Operating Cost (\$)', _operatingCostController),
              buildTextField(
                  'Maintenance Cost (\$)', _maintenanceCostController),
              buildTextField('Annual Energy (KWh)', _annualEnergyController),
              ElevatedButton(
                onPressed: calculateGeothermalCost,
                child: Text('Calculate'),
              ),
              SizedBox(height: 20),
              Text('GENERATION COST', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Text('Fixed Cost \$ : ${fixedCost.toStringAsFixed(2)} per kWh'),
              Text(
                  'Variable Cost \$ : ${variableCost.toStringAsFixed(2)} per kWh'),
              Text(
                  'Cost per Unit \$/KWh ${costPerUnit.toStringAsFixed(2)} per kWh'),
              Text(
                  'Cost per Unit pkr/KWh ${costpkr.toStringAsFixed(2)} per kWh'),
            ],
          ),
        ),
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
