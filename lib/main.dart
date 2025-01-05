import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guwenyu/widgets/article_page.dart';
import 'widgets/setting_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
    return CupertinoApp(
        home: MyHomePage(),
        theme: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                    fontFamily: 'San Francisco Pro, PingFang SC',
                    color: Colors.black))));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book_solid),
            label: '古文',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil),
            label: '练习',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings_solid),
            label: '设置',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return ArticlePage();
          case 1:
            return Center(
              child: Text('Hello, Cupertino!'),
            );
          case 2:
            return SettingsPage();
          default:
            return Center(
              child: Text('Hello, Cupertino!'),
            );
        }
      },
    );
  }
}
