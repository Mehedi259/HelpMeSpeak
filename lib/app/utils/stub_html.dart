// lib/utils/stub_html.dart
// This is a stub file for non-web platforms

class AudioElement {
  AudioElement(String src);

  bool autoplay = false;
  bool controls = false;

  Stream get onEnded => const Stream.empty();

  void pause() {}
  void play() {}
  void remove() {}
}

class Body {
  void append(dynamic element) {}
}

class Document {
  Body? body;
}

final document = Document();