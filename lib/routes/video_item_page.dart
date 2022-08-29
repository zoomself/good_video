import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_video/base/utils/log_utils.dart';
import 'package:good_video/base/utils/screen_utils.dart';
import 'package:good_video/generated/assets.dart';
import 'package:video_player/video_player.dart';
import '../model/video_result_entity.dart';

class VideoItemPage extends StatefulWidget {
  final VideoResultList videoEntity;

  const VideoItemPage({Key? key, required this.videoEntity}) : super(key: key);

  @override
  State<VideoItemPage> createState() => _VideoItemPageState();
}

class _VideoItemPageState extends State<VideoItemPage> {
  late VideoPlayerController _videoController;

  ///视频
  Widget _getVideoView() {
    if (!_videoController.value.isInitialized) {
      return Center(
          child: Image.network(
        "${widget.videoEntity.coverUrl}",
        errorBuilder: (context, error, stackTrace) {
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              "加载失败:$error",
              softWrap: true,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          );
        },
      ));
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            VideoPlayer(_videoController),
            Visibility(
              visible: !_videoController.value.isPlaying,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  Assets.imagesIcPlay,
                  width: 60,
                  height: 60,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///视频进度
  Widget _getProgressView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Slider(
          max: _videoController.value.duration.inMilliseconds.toDouble(),
          inactiveColor: const Color(0xff1a1a1a),
          activeColor: Colors.white,
          thumbColor: Colors.white,
          value: _videoController.value.position.inMilliseconds.toDouble(),
          onChanged: (v) {
            _videoController.seekTo(Duration(milliseconds: v.toInt()));
          }),
    );
  }

  /// 名字 标题
  Widget _getTitleView() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 名字
          Text(
            "@${widget.videoEntity.userName}",
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          // 标题
          Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                "${widget.videoEntity.title}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ))
        ],
      ),
    ));
  }

  ///关注点赞评论收藏转发
  Widget _getSocialView() {
    return Container(
      margin:
          EdgeInsets.only(right: 16, left: ScreenUtils.getScreenWidth() / 7),
      child: Column(
        children: [
          //头像，点关注
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              const SizedBox(
                width: 40,
                height: 50,
              ),
              InkWell(
                child: ClipOval(
                  child: Image.network(
                    widget.videoEntity.userPic!,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stack) {
                      return ClipOval(
                          child: Image.asset(
                        Assets.imagesDefeat,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ));
                    },
                  ),
                ),
                onTap: () {
                  Fluttertoast.showToast(msg: "点击头像");
                },
              ),
              InkWell(child: Container(
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                child: Image.asset(
                  Assets.imagesIcAdd,
                  width: 20,
                  height: 20,
                ),
              ),onTap: (){
                Fluttertoast.showToast(msg: "点击关注");
              },)

            ],
          ),
          //点赞
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Image.asset(
                    Assets.imagesIcZMomentLike,
                    color: Colors.white,
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "0",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
          //评论
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Image.asset(Assets.imagesIcZMomentComment,
                      color: Colors.white),
                  const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "0",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
          //收藏
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Image.asset(Assets.imagesIcZMomentCollect,
                      color: Colors.white),
                  const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "0",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
          //转发
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Image.asset(Assets.imagesIcZMomentShare, color: Colors.white),
                  const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "0",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///初始化视频控制器
  void _initVideoController() {
    _videoController =
        VideoPlayerController.network("${widget.videoEntity.playUrl}");
    _videoController.initialize().then((value) {
      setState(() {});
    });
    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.play();
  }

  @override
  void initState() {
    super.initState();
    _initVideoController();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          child: _getVideoView(),
          onTap: () {
            if (!_videoController.value.isInitialized) {
              _initVideoController();
            } else {
              if (_videoController.value.isPlaying) {
                _videoController.pause();
              } else {
                _videoController.play();
              }
            }
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Opacity(
              opacity: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [_getTitleView(), _getSocialView()],
              ),
            ),
            _getProgressView()
          ],
        )
      ],
    );
  }
}
