import 'dart:async';
import 'dart:html';
import 'dart:math';

class Graphics {
  CanvasElement _canvas;
  CanvasRenderingContext2D _graphics;

  Graphics._internal(this._canvas) : _graphics = _canvas.getContext("2d");

  factory Graphics.blank([String className]) => new Graphics._internal(new CanvasElement()..className = className ?? '');

  get canvas => _canvas;
  get width => _canvas.width;
  get height => _canvas.height;

  void setSize(width, height) {
    _canvas.width = width;
    _canvas.height = height;
  }

  void drawLine(x1, y1, x2, y2) {
    _graphics.moveTo(x1, y1);
    _graphics.lineTo(x2, y2);
    _graphics.stroke();
  }

  void drawOval(x, y, r) {
    _graphics.beginPath();
    _graphics.arc(x, y, r, 0, 2 * PI);
    _graphics.stroke();
  }

  void drawText(text, x, y) {
    _graphics.font = "30px Arial";
    _graphics.strokeText(text, x, y);
  }

  void fillText(text, x, y) {
    _graphics.font = "30px Arial";
    _graphics.fillText(text, x, y);
  }

  void drawRect(x1, y1, width, height) {
    _graphics.rect(x1, y1, width, height);
    _graphics.stroke();
  }

  void fillRect(x1, y1, width, height, {gradient}) {
    if (gradient != null) _graphics.fillStyle = gradient;
    _graphics.fillRect(x1, y1, width, height);
  }

  void setColor(color) {
    _graphics.strokeStyle = color;
  }

  void setFillColor(color) {
    _graphics.fillStyle = color;
  }

  void clear() {
    clearRect(0, 0, width, height);
  }

  void clearRect(x1, y1, width, height) {
    _graphics.clearRect(x1, y1, width, height);
  }

  Future<Null> drawImage(String image, x, y, [w, h]) async {
    ImageElement img = new ImageElement(src: image);
    img.onLoad.listen((e) {
      if (w == null || h == null) {
        _graphics.drawImage(img, x, y);
      } else {
        _graphics.drawImageScaled(img, x, y, w, h);
      }
    });
    await img.onLoad.first;
  }

  void drawPreloadedImage(ImageElement img, x, y, [w, h]) {
    if (w == null || h == null) {
      _graphics.drawImage(img, x, y);
    } else {
      _graphics.drawImageScaled(img, x, y, w, h);
    }
  }

  void drawCanvas(CanvasElement canvas) {
    _graphics.drawImage(canvas, 0, 0);
  }
}
