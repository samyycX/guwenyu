import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:guwenyu/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _analyzeArticlePrompt = """
[GOAL]
接下来我会给你一段文言文，内容在[ARTICLE]板块中。以 [REPLY FORMAT]中的要求回答。
[GOAL 0]: 获取除去标题和作者的原文。
[GOAL 1]: 获取文章的标题和作者和朝代，如果有的话则从文中提取，文中没有并且你明确知道的情况下填入你知道的，否则填null。
[GOAL 2]: 如果运用了典故，解析这个典故。
[GOAL 3]: 翻译全文。
[GOAL 4]: 提取文章主旨。
[REPLY FORMAT]
格式：minimized json。
结构：
content: [GOAL 0]的结果，string。
title: [GOAL 1]的结果，string。
author: [GOAL 1]的结果，string。格式：[朝代]·[作者]。
references: [GOAL 2的返回结果，json数组，如果没有运用典故则返回空。
- allusion: 原句
- explanation: 解析，包括解析典故本身的故事和意思和这里的引申义。
translation: [GOAL 3]的结果，string。
purport: [GOAL 4]的结果，string。
[ARTICLE]
%article%
""";

class LLMService {
  static final LLMService _instance = LLMService._internal();

  factory LLMService() {
    return _instance;
  }

  LLMService._internal();

  Future<String> _getBaseUrlFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('llm_base_url') ?? 'https://api.openai.com';
  }

  Future<String> _getApiKeyFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('llm_api_key') ?? '';
  }

  Future<String> _getModelFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('llm_model') ?? 'gpt-4o';
  }

  Future<List<String>> getAvailableModels() async {
    final models = await OpenAI.instance.model.list();
    return models.map((model) => model.id).toList();
  }

  Future<void> setBaseUrl(String baseUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('llm_base_url', baseUrl);
    OpenAI.baseUrl = baseUrl;
  }

  Future<void> setModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('llm_model', model);
  }

  Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('llm_api_key', apiKey);
    OpenAI.apiKey = apiKey;
  }

  Future<String> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('llm_api_key') ?? '';
    OpenAI.apiKey = apiKey;
    return apiKey;
  }

  Future<String> loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = prefs.getString('llm_base_url') ?? 'https://api.openai.com';
    OpenAI.baseUrl = baseUrl;
    return baseUrl;
  }

  Future<String> loadModel() async {
    final prefs = await SharedPreferences.getInstance();
    final model = prefs.getString('llm_model') ?? 'gpt-4o';
    return model;
  }

  Future<String?> sendRequest(String prompt) async {
    OpenAI.apiKey = await _getApiKeyFromLocalStorage();
    OpenAI.baseUrl = await _getBaseUrlFromLocalStorage();

    final model = await _getModelFromLocalStorage();

    final message = [
      OpenAIChatCompletionChoiceMessageModel(content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "你现在需要扮演一个文言文专家，用你最专业最严谨的知识，帮助用户解答文言文相关的问题。所有回答用JSON格式响应，并且严格符合接下来的JSON字段名要求。")
      ], role: OpenAIChatMessageRole.system),
      OpenAIChatCompletionChoiceMessageModel(content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
      ], role: OpenAIChatMessageRole.user)
    ];

    final chatCompletion = await OpenAI.instance.chat.create(
      model: model,
      responseFormat: {"type": "json_object"},
      messages: message,
    );

    return chatCompletion.choices.first.message.content?.first.text;
  }

  Future<Article> analyzeArticle(String article) async {
    final response = await sendRequest(
        _analyzeArticlePrompt.replaceAll("%article%", article));
    return Article.fromJson(jsonDecode(response ?? '{}'));
  }
}
