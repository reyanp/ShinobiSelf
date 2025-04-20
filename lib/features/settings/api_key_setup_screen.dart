import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/services/openai_service.dart';

class ApiKeySetupScreen extends StatefulWidget {
  const ApiKeySetupScreen({Key? key}) : super(key: key);

  @override
  State<ApiKeySetupScreen> createState() => _ApiKeySetupScreenState();
}

class _ApiKeySetupScreenState extends State<ApiKeySetupScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isLoading = true;
  bool _hasKey = false;
  
  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }
  
  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }
  
  Future<void> _loadApiKey() async {
    final apiKey = await OpenAIService.getApiKey();
    setState(() {
      _hasKey = apiKey != null && apiKey.isNotEmpty;
      _isLoading = false;
      if (_hasKey) {
        _apiKeyController.text = '••••••••••••••••••••••••';
      }
    });
  }
  
  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid API key'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    await OpenAIService.saveApiKey(apiKey);
    
    setState(() {
      _hasKey = true;
      _isLoading = false;
      _apiKeyController.text = '••••••••••••••••••••••••';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('API key saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Key Setup'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.api,
                    size: 64,
                    color: AppColors.chakraBlue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'OpenAI API Key',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To generate AI missions, you need to provide your OpenAI API key. This key will be stored securely on your device.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildApiKeyLink(),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: _hasKey ? null : 'Enter your OpenAI API key',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.paste),
                        onPressed: () async {
                          final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                          if (clipboardData?.text != null && clipboardData!.text!.isNotEmpty) {
                            setState(() {
                              _apiKeyController.text = clipboardData.text!;
                            });
                          }
                        },
                      ),
                    ),
                    obscureText: _hasKey,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveApiKey,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.chakraBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _hasKey ? 'Update API Key' : 'Save API Key',
                        style: AppTextStyles.buttonMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(),
                ],
              ),
            ),
    );
  }
  
  Widget _buildApiKeyLink() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to get an API key',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '1. Visit openai.com and create an account\n'
                  '2. Go to API section and create a new API key\n'
                  '3. Copy the key and paste it here',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About AI Missions',
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'AI missions are personalized tasks generated based on your character path traits. '
            'The system selects a random trait (with higher preference for your character\'s primary traits) '
            'and uses AI to create a mission to help you develop that trait.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Note: OpenAI API usage may incur charges according to their pricing policy.',
            style: AppTextStyles.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
} 