import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shinobi_self/config/api_keys.dart';

class OpenAIService {
  static const String baseUrl = 'https://api.openai.com/v1/chat/completions';
  
  // Get API key from config
  static String getApiKey() {
    return ApiKeys.openAI;
  }
  
  // Generate a mission based on a trait using OpenAI API
  static Future<String?> generateMission(String trait, String characterName) async {
    final apiKey = getApiKey();
    if (apiKey.isEmpty || apiKey == 'YOUR_OPENAI_API_KEY') {
      print('Please set your OpenAI API key in lib/config/api_keys.dart');
      return null; // No API key available
    }
    
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that creates personalized mission tasks for a Naruto-themed mental wellness app called Shinobi Self. Your response should ONLY include two lines: a title on the first line and a description on the second line. No other text, commentary, or formatting.'
            },
            {
              'role': 'user',
              'content': 'Create a mission for a user following the $characterName path who is working on developing their "$trait" trait.\n\nYour response must follow this EXACT format:\nLine 1: A title with first letters capitalized (example: "Focus Your Energy Like A Ninja")\nLine 2: A one-sentence description that explains the mission.\n\nDo not include any quotes, asterisks, or additional text in your response.'
            }
          ],
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'].toString().trim();
      } else {
        print('Error calling OpenAI API: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception when calling OpenAI API: $e');
      return null;
    }
  }
} 