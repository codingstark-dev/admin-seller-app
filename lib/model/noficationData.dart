import 'package:flutter/material.dart';

class Post {
  final String image;
  final int id;
  final String title;
  final String desc;

  Post({this.image, this.id, this.title, this.desc});
}

@immutable
class MsgData {
  final String image;
  final int id;
  final String title;
  final String desc;

  MsgData({this.image, this.id, this.title, this.desc});
}
