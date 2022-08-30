import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_video/base/net/net_client.dart';
import 'package:good_video/model/video_result_entity.dart';
import 'package:good_video/routes/video_item_page.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
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
    return EasyRefresh(
        controller: _refreshController,
        header: const ClassicHeader(textStyle: TextStyle(color: Colors.white)),
        footer: const ClassicFooter(textStyle: TextStyle(color: Colors.white)),
        onRefresh: () {
          _refresh();
        },
        onLoad: () {
          _loadMore();
        },
        child: PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            return VideoItemPage(
              videoEntity: _dataList[index],
            );
          },
          itemCount: _dataList.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (page){
            //提前2页自动加载
            if(page==_dataList.length-2){
              _loadMore();
            }
          },
        ));
  }

  @override
  void initState() {
    _pageController = PageController();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
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
            statusBarIconBrightness: Brightness.dark),
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
