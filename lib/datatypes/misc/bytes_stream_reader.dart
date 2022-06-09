class BytesStreamReader {
  final List<int> _drained = [];
  final Stream<List<int>> _readStream;
  final int _size;

  /// Important: providing an incorrect size may lead
  /// to infinite loop in [bytes] getter
  BytesStreamReader({
    required readStream,
    required size,
  })  : _readStream = readStream,
        _size = size;

  Future<List<int>> get bytes async {
    // TODO: big files loading error

    while (_drained.length != _size) {
      _drained.addAll(await _readStream.first);
    }
    return _drained;
  }
}
