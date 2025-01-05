import 'package:flutter/cupertino.dart';
import 'package:guwenyu/backend/llm/llmservice.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final TextEditingController _baseUrlController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  FixedExtentScrollController? _modelScrollController;
  List<String> _models = [];
  String? _selectedModel;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() async {
    final apiKey = await LLMService().loadApiKey();
    final baseUrl = await LLMService().loadBaseUrl();
    final model = await LLMService().loadModel();
    setState(() {
      _apiKeyController.text = apiKey;
      _baseUrlController.text = baseUrl;
      _selectedModel = model;
      _fetchModels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: Form(
          child: CupertinoFormSection.insetGrouped(
            header: const Text('LLM API'),
            children: <Widget>[
              CupertinoTextFormFieldRow(
                controller: _apiKeyController,
                prefix: Text('API Key'),
                placeholder: 'API Key',
                obscureText: true,
                onFieldSubmitted: (value) {
                  LLMService().setApiKey(value);
                },
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              CupertinoTextFormFieldRow(
                controller: _baseUrlController,
                prefix: Text('Base URL'),
                placeholder: 'Base URL',
                onFieldSubmitted: (value) {
                  LLMService().setBaseUrl(value);
                  _fetchModels();
                },
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              CupertinoFormRow(
                prefix: Text('模型'),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: CupertinoButton(
                  onPressed: () => _showModelPicker(context),
                  child: Text(_selectedModel ?? '请选择模型'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _fetchModels() async {
    if (_baseUrlController.text != "") {
      final models = await LLMService().getAvailableModels();
      setState(() {
        _models = models;
        _modelScrollController = FixedExtentScrollController(
          initialItem: _models.indexOf(_selectedModel ?? ''),
        );
      });
    }
  }

  void _showModelPicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                height: 200,
                child: CupertinoPicker(
                  scrollController: _modelScrollController,
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedModel = _models[index];
                      LLMService().setModel(_selectedModel!);
                    });
                  },
                  children: _models.map((model) => Text(model)).toList(),
                  useMagnifier: true,
                  magnification: 1.5,
                  squeeze: 1.2,
                ),
              ),
              CupertinoButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
