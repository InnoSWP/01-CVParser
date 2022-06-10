import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum KeyEvent {
  escPressed,
  escReleased,
  // NOTE: i'm too lazy to fulfill this thing,
  // as now it's enough of this functionality
}

class KeyListener extends GetxService {
  var esc = false;
  var ctrl = false;
  var shift = false;

  final _escEventStream = StreamController<KeyEvent>.broadcast();

  Stream<KeyEvent> get escEventStream => _escEventStream.stream;

  KeyListener() {
    window.onKeyData = (final keyData) {
      if (keyData.type != KeyEventType.repeat) {
        if (keyData.logical == LogicalKeyboardKey.escape.keyId) {
          esc = keyData.type == KeyEventType.down;
          _escEventStream.add(esc ? KeyEvent.escPressed : KeyEvent.escReleased);
        } else if (keyData.logical == LogicalKeyboardKey.controlLeft.keyId ||
            keyData.logical == LogicalKeyboardKey.controlRight.keyId) {
          ctrl = keyData.type == KeyEventType.down;
        } else if (keyData.logical == LogicalKeyboardKey.shiftLeft.keyId ||
            keyData.logical == LogicalKeyboardKey.shiftRight.keyId) {
          shift = keyData.type == KeyEventType.down;
        }
      }

      // Let event pass to other focuses if it is not the key we looking for
      return false;
    };
  }

  @override
  void onClose() {
    _escEventStream.close();
  }
}
