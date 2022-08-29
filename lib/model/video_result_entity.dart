import 'package:good_video/generated/json/base/json_field.dart';
import 'package:good_video/generated/json/video_result_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class VideoResultEntity {

	List<VideoResultList>? list;
	int? total;
  
  VideoResultEntity();

  factory VideoResultEntity.fromJson(Map<String, dynamic> json) => $VideoResultEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoResultEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoResultList {

	String? coverUrl;
	String? duration;
	int? id;
	String? playUrl;
	String? title;
	String? userName;
	String? userPic;
  
  VideoResultList();

  factory VideoResultList.fromJson(Map<String, dynamic> json) => $VideoResultListFromJson(json);

  Map<String, dynamic> toJson() => $VideoResultListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}