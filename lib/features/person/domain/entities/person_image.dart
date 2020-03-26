import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class PersonImage extends Equatable {
  final Image image;

  PersonImage({@required this.image});

  @override
  List<Object> get props => [image];
}
