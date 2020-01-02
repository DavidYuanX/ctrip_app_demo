import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577892165738&di=d3b12c26a39d44dd0ce6536ec04c4abe&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fef6043c0f407dac052c3b53b533274e30feb8b3e810f-dzocHu_fw658',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577892165738&di=d3b12c26a39d44dd0ce6536ec04c4abe&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fef6043c0f407dac052c3b53b533274e30feb8b3e810f-dzocHu_fw658',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577892165738&di=d3b12c26a39d44dd0ce6536ec04c4abe&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fef6043c0f407dac052c3b53b533274e30feb8b3e810f-dzocHu_fw658',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577892165738&di=d3b12c26a39d44dd0ce6536ec04c4abe&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fef6043c0f407dac052c3b53b533274e30feb8b3e810f-dzocHu_fw658',
  ];
  double appBarAlpha = 0;

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }

  String showResult = '';
  String countString = '';
  String localCount = '';

  Future<CommonModel> fetchPost() async {
    final response = await http
        .get('http://www.devio.org/io/flutter_app/json/test_common_model.json');
    Utf8Decoder utf8decoder = Utf8Decoder();
    final result = json.decode(utf8decoder.convert(response.bodyBytes));
    return CommonModel.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 160,
                        child: Swiper(
                          itemCount: _imageUrls.length,
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              _imageUrls[index],
                              fit: BoxFit.fill,
                            );
                          },
                          pagination: SwiperPagination(),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            fetchPost().then((CommonModel value) {
                              setState(() {
                                showResult =
                                    '请求结果：\nhideAppBar: ${value.hideAppBar}\nicon: ${value.icon}';
                              });
                            });
                          },
                          child: Text(
                            '点我',
                            style: TextStyle(fontSize: 26),
                          )),
                      Text(showResult),
                      FutureBuilder<CommonModel>(
                          future: fetchPost(),
                          builder: (BuildContext context,
                              AsyncSnapshot<CommonModel> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text('Input a Url to start');
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.active:
                                return new Text('');
                              case ConnectionState.done:
                                if (snapshot.hasError) {
                                  return new Text(
                                    '${snapshot.error}',
                                    style: TextStyle(color: Colors.red),
                                  );
                                } else {
                                  return new Column(
                                    children: <Widget>[
                                      Text('icon:${snapshot.data.icon}'),
                                      Text(
                                          'statusBarColor:${snapshot.data.statusBarColor}'),
                                      Text('title:${snapshot.data.title}'),
                                      Text('url:${snapshot.data.url}'),
                                    ],
                                  );
                                }
                            }
                          }),
                      RaisedButton(
                        onPressed: _incrementCounter,
                        child: Text('Increment Count'),
                      ),
                      RaisedButton(
                        onPressed: _getCounter,
                        child: Text('Get Count'),
                      ),
                      Text(
                        countString,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        localCount,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text('111')
                    ],
                  ))),
          Opacity(
            opacity: appBarAlpha,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('首页'),
                ),
              ),
            ),
          ),
//          Text(showResult)
        ],
      ),
    );
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      countString = countString + " 1";
    });
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
  }

  _getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      localCount = prefs.getInt('counter').toString();
    });
  }
}

class CommonModel {
  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;

  CommonModel(
      {this.icon, this.title, this.url, this.statusBarColor, this.hideAppBar});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
        icon: json['icon'],
        title: json['title'],
        url: json['url'],
        statusBarColor: json['statusBarColor'],
        hideAppBar: json['hideAppBar']);
  }
}
