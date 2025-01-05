import 'package:flutter/cupertino.dart';
import '../models/article.dart';

class ArticleDetail extends StatefulWidget {
  final Article article;

  const ArticleDetail({super.key, required this.article});

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  bool _isTranslationVisible = false;
  bool _isPurportVisible = false;
  bool _isReferencesVisible = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.article.title),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.title,
                style:
                    CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
              ),
              SizedBox(height: 8.0),
              Text(
                '作者 ${widget.article.author}',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.article.content,
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        onPressed: () {
                          setState(() {
                            _isTranslationVisible = !_isTranslationVisible;
                          });
                        },
                        child: Text(
                          '翻译',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                      ),
                    ),
                    if (_isTranslationVisible)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.article.translation,
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        onPressed: () {
                          setState(() {
                            _isPurportVisible = !_isPurportVisible;
                          });
                        },
                        child: Text(
                          '主旨',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                      ),
                    ),
                    if (_isPurportVisible)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.article.purport,
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        onPressed: () {
                          setState(() {
                            _isReferencesVisible = !_isReferencesVisible;
                          });
                        },
                        child: Text(
                          '用典',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                      ),
                    ),
                    if (_isReferencesVisible)
                      ...widget.article.references.map((reference) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reference.allusion,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  reference.explanation,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle,
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
