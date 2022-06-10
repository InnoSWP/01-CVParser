enum BytesStreamDrainerState {
  initial,
  processing,
  filled,
}

class BytesStreamReader {
  final List<int> _drained = [];
  final Stream<List<int>> _readStream;
  BytesStreamDrainerState state = BytesStreamDrainerState.initial;
  Future<void>? drainer;

  BytesStreamReader({
    required readStream,
  }) : _readStream = readStream;

  Future<void> _drain() async {
    await for (final bucket in _readStream) {
      _drained.addAll(bucket);
    }
  }

  Future<List<int>> get bytes async {
    switch (state) {
      case BytesStreamDrainerState.initial:
        drainer = _drain();
        state = BytesStreamDrainerState.processing;
        await drainer;
        state = BytesStreamDrainerState.filled;
        break;
      case BytesStreamDrainerState.processing:
        await drainer;
        break;
      case BytesStreamDrainerState.filled:
        break;
      default:
        throw TypeError();
    }
    return _drained;
  }
}
