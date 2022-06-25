import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO: expand button
// TODO: autoclose
class NotificationCard extends StatelessWidget {
  final VoidCallback? onClose;
  final String msg;

  const NotificationCard({
    Key? key,
    this.onClose,
    required this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Get.theme.colorScheme.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SizedBox(
              width: 420,
              child: Text(
                msg,
                style: const TextStyle(
                  height: 1,
                  fontSize: 15,
                  fontFamily: "Merriweather",
                  fontWeight: FontWeight.w400,
                  color: colorTextSmoothBlack,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
