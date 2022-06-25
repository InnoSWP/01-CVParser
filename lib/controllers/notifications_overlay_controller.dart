import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsOverlayController extends GetxController {
  final scrollController = ScrollController();
  final notifications = <String>[].obs;

  void notify(String msg) {
    notifications.add(msg);
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 50,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void close(int index) {
    notifications.removeAt(index);
  }
}
