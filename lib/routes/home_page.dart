import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_video/base/net/net_client.dart';
import 'package:good_video/base/utils/screen_utils.dart';
import 'package:good_video/model/video_result_entity.dart';
import 'package:good_video/routes/video_item_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EasyRefreshController _refreshController;
  late PageController _pageController;
  final int _pageSize = 10;
  final List<VideoResultList> _dataList = [];
  int _currentPage = 0;
  bool _canLoadMore = true;

  ///获取数据
  void _getData() {
    String url =
        "https://api.apiopen.top/api/getHaoKanVideo?page=$_currentPage&size=$_pageSize";
    NetClient().get<VideoResultEntity>(url, onSuccess: (entity) {
      if (mounted) {
        setState(() {
          List<VideoResultList>? list = entity.list;
          if (list == null) {
            _canLoadMore = false;
          } else {
            if (list.length < _pageSize) {
              _canLoadMore = false;
            }
            if (_currentPage == 0) {
              _dataList.clear();
            }
            _dataList.addAll(list);
          }
          _getDataComplete();
        });
      }
    });
  }

  ///加载数据完成
  void _getDataComplete() {
    if (_currentPage == 0) {
      _refreshController.finishRefresh();
    } else {
      _refreshController.finishLoad();
    }
  }

  ///刷新
  void _refresh() {
    _currentPage = 0;
    _canLoadMore = true;
    _getData();
  }

  ///加载更多
  void _loadMore() {
    if (_canLoadMore) {
      _currentPage++;
      _getData();
    } else {
      Fluttertoast.showToast(msg: "暂无更多数据");
    }
  }

  ///根据数据显示相应的内容页面
  Widget _getContentPage() {
    if (_dataList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        return VideoItemPage(
          videoEntity: _dataList[index],
        );
      },
      itemCount: _dataList.length,
      scrollDirection: Axis.vertical,
    );
  }

  @override
  void initState() {
    _pageController = PageController();
    _refreshController = EasyRefreshController();
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _pageController.dispose();
    super.dispose();
    _dataList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light),
        primary: true,
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          _getContentPage(),
          const SizedBox(
            width: double.infinity,
            height: kToolbarHeight,
            child: Center(
              child: Text(
                "好看视频",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
            ),
          )
        ],
      ),
    );
  }
}
