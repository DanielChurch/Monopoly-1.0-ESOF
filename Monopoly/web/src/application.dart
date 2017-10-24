import 'package:Monopoly/game/dice.dart';
import 'package:Monopoly/graphics/dom.dart';
import 'package:Monopoly/graphics/graphics.dart';

import 'dart:core';
import 'dart:html';
import 'dart:math';

Graphics g;
var mouseX, mouseY;

List<Dice> dice = [];

void main() {
  // Dice
  Element section = Dom.div()..className = 'cubeContainer';

  Dom.body.append(section);

  dice.add(new Dice(400, 0, 0, container: section));
  dice.add(new Dice(300, 0, 0, container: section));
  dice.add(new Dice(200, 0, 0, container: section));
  dice.add(new Dice(100, 0, 0, container: section));
  dice.add(new Dice(0, 0, 0, container: section));

//  document.onMouseDown.listen((m) => dice.forEach((d) => d.spin()));

  // Canvas
  g = new Graphics.blank();
  g.setSize(1280, 1280);

  mouseX = g.width / 2;
  mouseY = g.height / 2;

  bool mouseDown = false;

  document.onMouseMove.listen((MouseEvent e) {
    num lastX = mouseX;
    num lastY = mouseY;
    mouseX = e.client.x;
    mouseY = e.client.y;
    if (mouseDown) g.drawLine(lastX, lastY, mouseX, mouseY);
  });

  document.onMouseDown.listen((_) => mouseDown = true);
  document.onMouseUp.listen((_) => mouseDown = false);

  Dom.body.append(g.canvas);

  window.requestAnimationFrame(loop);
}

num now, dt = 0, last = window.performance.now(), step = 1/60;

void loop(_) {
  // Props to http://codeincomplete.com/posts/javascript-game-foundations-the-game-loop/
  // For this loop code
  now = window.performance.now();
  dt = dt + min(1, (now - last) / 1000);
  while(dt > step) {
    dt = dt - step;
    update();
  }
  render(dt);
  last = now;

  window.requestAnimationFrame(loop);
}

void update() {
  dice.forEach((d) => d.update());
}

void render(num delta) {
  dice.forEach((d) => d.render(delta));
}