import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ApiService {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";

  Future<List<Map<String, String>>> generateWorkout(
      String goal, String fitnessLevel, double workoutTime, String bodyPart) async {
    try {
      final String apiKey = await _getApiKey();
      if (apiKey.isEmpty) {
        print("API Key not found.");
        return [];
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "system", "content": "You are a fitness AI expert."},
            {
              "role": "user",
              "content":
              "Generate a workout plan for a $fitnessLevel level person whose goal is $goal. The workout should last $workoutTime minutes and focus on $bodyPart. Provide 3-5 exercises with sets, reps, rest time, and a note. Format the response such that each exercise contains a title that starts with 'Exercise Name:', the sets and reps that start with 'Sets and Reps:', the rest time that starts with 'Rest Time:', and the notes that start with 'Notes:'. Put each exercise on a new line."
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String aiText = responseBody["choices"][0]["message"]["content"];

        return _parseWorkoutPlan(aiText);
      } else {
        print("Failed: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  List<Map<String, String>> _parseWorkoutPlan(String aiText) {
    List<Map<String, String>> workoutPlan = [];
    List<String> exercises = aiText.split("Exercise Name:");

    for (int i = 1; i < exercises.length; i++) {
      String exerciseText = "Exercise Name:" + exercises[i];
      String name = _extractValue(exerciseText, "Exercise Name:");
      String sets = _extractValue(exerciseText, "Sets and Reps:");
      String rest = _extractValue(exerciseText, "Rest Time:");
      String notes = _extractValue(exerciseText, "Notes:");

      if (name.isNotEmpty) {
        workoutPlan.add({
          "name": name,
          "sets": sets,
          "rest": rest,
          "notes": notes,
        });
      }
    }
    return workoutPlan;
  }

  String _extractValue(String text, String prefix) {
    int startIndex = text.indexOf(prefix);
    if (startIndex != -1) {
      startIndex += prefix.length;
      int endIndex = text.indexOf("\n", startIndex);
      if (endIndex == -1) {
        return text.substring(startIndex).trim();
      } else {
        return text.substring(startIndex, endIndex).trim();
      }
    }
    return "";
  }

  Future<String> _getApiKey() async {
    try {
      return await const MethodChannel('flutter/platform').invokeMethod('getApiKey') ?? '';
    } catch (e) {
      print("Error getting API key: $e");
      return '';
    }
  }
}
