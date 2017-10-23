import 'dart:core';
import 'dart:html';

import 'package:Monopoly/dice.dart';
import 'package:Monopoly/dom.dart';
import 'package:Monopoly/graphics.dart';

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

  Dom.body.append(Dom.a("test"));

  loop(null);
}

void loop(_) {
  dice.forEach((d) => d.update());
  dice.forEach((d) => d.render());

  window.animationFrame.then(loop);
}
