import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:guwenyu/backend/llm/llmservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Should return proper answer', () async {
    HttpOverrides.global = null;
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('llm_base_url', 'https://api.deepseek.com');
    prefs.setString('llm_api_key', 'sk-a99af8685638405b8c5ab4e1caab1b1a');
    prefs.setString('llm_model', 'deepseek-chat');
    final llmService = LLMService();
    final response = await llmService.analyzeArticle(
        "山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？");
    print(response);
  });
}
