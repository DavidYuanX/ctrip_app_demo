import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
    double alpha = offset/APPBAR_SCROLL_OFFSET;
    if(alpha<0){
      alpha = 0;
    }else if(alpha>1){
      alpha=1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
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
                      Container(
                        height: 800,
                        child: ListTile(
                          title: Text('哈哈'),
                        ),
                      )
                    ],
                  ))
          ),
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
          )
        ],
      ),
    );
  }
}