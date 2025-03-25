import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  final List<Map<String, String>> workoutPlan;

  ResultsPage({required this.workoutPlan});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Map<String, String>> _displayedExercises = [];

  @override
  void initState() {
    super.initState();
    _dropExercisesOneByOne();
  }

  void _dropExercisesOneByOne() async {
    for (int i = 0; i < widget.workoutPlan.length; i++) {
      await Future.delayed(Duration(milliseconds: 400)); // Delay between items
      _displayedExercises.add(widget.workoutPlan[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generated Workout Plan"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Workout Plan For Today's Goal",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _displayedExercises.length,
                itemBuilder: (context, index, animation) {
                  final exercise = _displayedExercises[index];

                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: Offset(0, -1), // Starts from top
                        end: Offset(0, 0), // Drops into place
                      ).chain(CurveTween(curve: Curves.easeOut)),
                    ),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise["name"] ?? "Exercise",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text("Sets & Reps: ${exercise["sets"] ?? "N/A"}"),
                            Text("Rest Time: ${exercise["rest"] ?? "N/A"}"),
                            Text("Notes: ${exercise["notes"] ?? "N/A"}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Save Workout Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Workout saved successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Save Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
