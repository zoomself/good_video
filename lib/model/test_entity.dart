import 'package:good_video/generated/json/base/json_field.dart';
import 'package:good_video/generated/json/test_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class TestEntity {

	String? name;
	int? age;

  TestEntity();

  factory TestEntity.fromJson(Map<String, dynamic> json) => $TestEntityFromJson(json);

  Map<String, dynamic> toJson() => $TestEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}