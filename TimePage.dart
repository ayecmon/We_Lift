import 'package:flutter/material.dart';
import 'openai_service.dart';
import 'ResultsPage.dart';
import 'package:lottie/lottie.dart';

class TimePage extends StatefulWidget {
  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  String _selectedGoal = 'Lose Weight';
  double _workoutTime = 30;
  String _selectedFitnessLevel = 'Beginner';
  String _selectedBodyPart = 'Full Body';
  bool _loading = false;

  void _generateWorkout() async {
    setState(() {
      _loading = true;
    });

    ApiService apiService = ApiService();
    List<Map<String, String>> workoutPlan = await apiService.generateWorkout(
      _selectedGoal, _selectedFitnessLevel, _workoutTime, _selectedBodyPart,
    );

    setState(() {
      _loading = false;
    });

    if (workoutPlan.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultsPage(workoutPlan: workoutPlan)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate workout. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Goal"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Main content with scrolling
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Select Your Workout Plan",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    _buildDropdownWithLabel("Goal", _selectedGoal, (newValue) {
                      setState(() {
                        _selectedGoal = newValue!;
                      });
                    }, ["Lose Weight", "Build Muscle", "Increase Stamina"]),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Workout Time: ${_workoutTime.toInt()} minutes",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 8),
                    Slider(
                      value: _workoutTime,
                      min: 10,
                      max: 120,
                      divisions: 11,
                      label: "${_workoutTime.toInt()} min",
                      onChanged: (newValue) {
                        setState(() {
                          _workoutTime = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    _buildDropdownWithLabel("Fitness Level", _selectedFitnessLevel, (newValue) {
                      setState(() {
                        _selectedFitnessLevel = newValue!;
                      });
                    }, ["Beginner", "Intermediate", "Advanced"]),
                    SizedBox(height: 30),
                    _buildDropdownWithLabel("Body Part to Focus On", _selectedBodyPart, (newValue) {
                      setState(() {
                        _selectedBodyPart = newValue!;
                      });
                    }, ["Full Body", "Upper Body", "Lower Body", "Core"]),
                    SizedBox(height: 80),
                    ElevatedButton(
                      onPressed: _generateWorkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                        textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Generate Workout"),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Full-screen Loading Overlay
          if (_loading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Lottie.asset(
                    'assets/loading.json',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildDropdownWithLabel(String label, String value, Function(String?) onChanged, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            isExpanded: true,
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderWithLabel(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Slider(
          value: value,
          min: 10,
          max: 120,
          divisions: 11,
          label: "${value.toInt()} min",
          onChanged: onChanged,
        ),
      ],
    );
  }
}
