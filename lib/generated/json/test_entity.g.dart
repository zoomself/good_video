import 'package:good_video/generated/json/base/json_convert_content.dart';
import 'package:good_video/model/test_entity.dart';

TestEntity $TestEntityFromJson(Map<String, dynamic> json) {
	final TestEntity testEntity = TestEntity();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		testEntity.name = name;
	}
	final int? age = jsonConvert.convert<int>(json['age']);
	if (age != null) {
		testEntity.age = age;
	}
	return testEntity;
}

Map<String, dynamic> $TestEntityToJson(TestEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['age'] = entity.age;
	return data;
}