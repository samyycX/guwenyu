import 'package:flutter/cupertino.dart';
import 'package:guwenyu/backend/service.dart';
import 'package:guwenyu/models/article.dart';
import 'package:guwenyu/widgets/article_detail.dart';
import 'package:guwenyu/widgets/article_page_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticlePage extends StatelessWidget {
  Widget fromArticle(BuildContext context, Article article) {
    return CupertinoListTile.notched(
      title: Text(article.title),
      subtitle: Text(article.author),
      trailing: CupertinoListTileChevron(),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ArticleDetail(article: article),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('古文'),
      ),
      child: SafeArea(
        child: Form(
          child: Column(
            children: [
              CupertinoFormSection.insetGrouped(
                header: Text('导入'),
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ArticlePageInput(),
                          ),
                        );
                      },
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('手动输入...'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () async {
                        final perfs = await SharedPreferences.getInstance();
                        perfs.setStringList('articles', []);
                      },
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('从剪切板粘贴...'),
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<Article>>(
                future: BackendService().loadArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CupertinoActivityIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('暂无文章。'));
                  } else {
                    return CupertinoListSection.insetGrouped(
                      header: Text('历史文章'),
                      children: snapshot.data!
                          .map((article) => fromArticle(context, article))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
