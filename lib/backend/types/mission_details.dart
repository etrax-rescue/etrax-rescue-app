import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum DetailType {
  text,
  image,
}

abstract class MissionDetail extends Equatable {
  MissionDetail({@required this.title, @required this.type});

  final String title;
  final DetailType type;

  Map<String, String> toJson();
}

class MissionDetailText extends MissionDetail {
  MissionDetailText({@required this.title, @required this.body})
      : super(type: DetailType.text, title: title);
  final String title;
  final String body;

  factory MissionDetailText.fromJson(Map<String, dynamic> json) {
    return MissionDetailText(title: json['title'], body: json['body']);
  }

  @override
  Map<String, String> toJson() {
    return {
      'type': 'text',
      'title': this.title,
      'body': this.body,
    };
  }

  @override
  List<Object> get props => [title, type, body];
}

class MissionDetailImage extends MissionDetail {
  MissionDetailImage({@required this.title, @required this.uid})
      : super(type: DetailType.image, title: title);
  final String title;
  final String uid;

  factory MissionDetailImage.fromJson(Map<String, dynamic> json) {
    return MissionDetailImage(title: json['title'], uid: json['uid']);
  }

  @override
  Map<String, String> toJson() {
    return {
      'type': 'image',
      'title': this.title,
      'uid': this.uid,
    };
  }

  @override
  List<Object> get props => [title, type, uid];
}

class MissionDetailCollection extends Equatable {
  MissionDetailCollection({@required this.details});

  final List<MissionDetail> details;

  factory MissionDetailCollection.fromJson(List<dynamic> json) {
    List<MissionDetail> detailList;

    Iterable it = json;
    detailList = List<MissionDetail>.from(it.map((el) {
      if (el['type'] == 'text') {
        return MissionDetailText.fromJson(el);
      } else if (el['type'] == 'image') {
        return MissionDetailImage.fromJson(el);
      }
    }).toList());

    return MissionDetailCollection(details: detailList);
  }

  List<Map<String, String>> toJson() {
    final jsonList = List<Map<String, String>>.from(details
        .map((e) => e is MissionDetail ? e.toJson() : throw FormatException())
        .toList());
    return jsonList;
  }

  @override
  List<Object> get props => [details];
}
