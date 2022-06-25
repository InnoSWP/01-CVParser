import 'package:cvparser_b21_01/controllers/notifications_overlay_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notifications_overlay/notification_card.dart';

// TODO: animations for closing
class NotificationsOverlay extends GetView<NotificationsOverlayController> {
  const NotificationsOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 490,
      height: 195,
      child: Obx(
        () => ListView.builder(
          controller: controller.scrollController,
          shrinkWrap: true,
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            return NotificationCard(
              msg: controller.notifications[index],
              onClose: () => controller.close(index),
            );
          },
        ),
      ),
    );
  }
}
