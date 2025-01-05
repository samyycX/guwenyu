import 'package:guwenyu/backend/llm/llmservice.dart';
import 'package:guwenyu/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackendService {
  static final BackendService _instance = BackendService._internal();

  BackendService._internal();

  factory BackendService() {
    return _instance;
  }

  Future<Article> analyzeArticle(String article) async {
    final llmService = LLMService();
    final articleObj = await llmService.analyzeArticle(article);
    final perfs = await SharedPreferences.getInstance();
    final articles = perfs.getStringList("articles") ?? [];
    articles.add(articleToJson(articleObj));
    await perfs.setStringList("articles", articles);
    return articleObj;
  }

  Future<List<Article>> loadArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final articles = prefs.getStringList("articles") ?? [];
    return articles.map((article) => articleFromJson(article)).toList();
  }
}
