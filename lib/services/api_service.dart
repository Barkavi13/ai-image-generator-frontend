import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> generatePrompt(String prompt) async {
    final response = await http.post(
      Uri.parse("https://ai-image-generator-backend-m5bz.onrender.com"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"prompt": prompt}),
    );

    return jsonDecode(response.body);
  }
}
