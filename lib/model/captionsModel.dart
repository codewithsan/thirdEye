class Captions {
  String? _text;
  double? _confidence;

  String? get text => _text;
  double? get confidence => _confidence;

  Captions({required String? text, required double confidence}) {
    this._text = text;
    this._confidence = confidence;
  }

  Captions.fromJson(Map<String, dynamic> json) {
    _text = json['text'];
    _confidence = json['confidence'];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Captions &&
        other._text == _text &&
        other._confidence == _confidence;
  }

  @override
  int get hashCode => _text.hashCode ^ _confidence.hashCode;

  @override
  String toString() => 'Captions(_text: $_text, _confidence: $_confidence)';
}
