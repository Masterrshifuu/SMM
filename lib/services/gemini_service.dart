import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with your actual API key
  late final GenerativeModel _model;

  GeminiService() {
    if (_apiKey == 'YOUR_GEMINI_API_KEY') {
      throw Exception('Please set your Gemini API key');
    }
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  Future<String> generateResponse(String prompt) async {
    try {
      if (prompt.trim().isEmpty) {
        return 'Please enter a valid prompt';
      }

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text == null || response.text!.isEmpty) {
        return 'Sorry, I could not generate a response.';
      }
      
      return response.text!;
    } on GenerativeAIException catch (e) {
      return 'AI Error: ${e.message}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
