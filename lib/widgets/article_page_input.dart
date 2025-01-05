import 'package:flutter/cupertino.dart';
import 'package:guwenyu/backend/service.dart';

class ArticlePageInput extends StatefulWidget {
  @override
  ArticlePageInputState createState() => ArticlePageInputState();
}

class ArticlePageInputState extends State<ArticlePageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _onConfirm() async {
    setState(() {
      _isLoading = true;
    });

    await BackendService().analyzeArticle(_controller.text);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('导入'),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Form(
              child: Column(
                children: <Widget>[
                  CupertinoFormSection.insetGrouped(
                    header: Text('导入'),
                    children: <Widget>[
                      CupertinoTextField(
                        placeholder: '输入文章',
                        keyboardType: TextInputType.multiline,
                        controller: _controller,
                        maxLines: null,
                        minLines: 5,
                      )
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 0.0),
                          child: CupertinoButton(
                            padding: EdgeInsets.all(0),
                            onPressed: _onConfirm,
                            child: Text('确认'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
