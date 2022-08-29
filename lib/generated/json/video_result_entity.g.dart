import 'package:good_video/generated/json/base/json_convert_content.dart';
import 'package:good_video/model/video_result_entity.dart';

VideoResultEntity $VideoResultEntityFromJson(Map<String, dynamic> json) {
	final VideoResultEntity videoResultEntity = VideoResultEntity();
	final List<VideoResultList>? list = jsonConvert.convertListNotNull<VideoResultList>(json['list']);
	if (list != null) {
		videoResultEntity.list = list;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		videoResultEntity.total = total;
	}
	return videoResultEntity;
}

Map<String, dynamic> $VideoResultEntityToJson(VideoResultEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['list'] =  entity.list?.map((v) => v.toJson()).toList();
	data['total'] = entity.total;
	return data;
}

VideoResultList $VideoResultListFromJson(Map<String, dynamic> json) {
	final VideoResultList videoResultList = VideoResultList();
	final String? coverUrl = jsonConvert.convert<String>(json['coverUrl']);
	if (coverUrl != null) {
		videoResultList.coverUrl = coverUrl;
	}
	final String? duration = jsonConvert.convert<String>(json['duration']);
	if (duration != null) {
		videoResultList.duration = duration;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		videoResultList.id = id;
	}
	final String? playUrl = jsonConvert.convert<String>(json['playUrl']);
	if (playUrl != null) {
		videoResultList.playUrl = playUrl;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		videoResultList.title = title;
	}
	final String? userName = jsonConvert.convert<String>(json['userName']);
	if (userName != null) {
		videoResultList.userName = userName;
	}
	final String? userPic = jsonConvert.convert<String>(json['userPic']);
	if (userPic != null) {
		videoResultList.userPic = userPic;
	}
	return videoResultList;
}

Map<String, dynamic> $VideoResultListToJson(VideoResultList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['coverUrl'] = entity.coverUrl;
	data['duration'] = entity.duration;
	data['id'] = entity.id;
	data['playUrl'] = entity.playUrl;
	data['title'] = entity.title;
	data['userName'] = entity.userName;
	data['userPic'] = entity.userPic;
	return data;
}