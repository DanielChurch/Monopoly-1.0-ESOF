import 'package:monopoly/game/banker.dart';
import 'package:monopoly/game/player.dart';
import 'package:monopoly/graphics/dom.dart';
import 'package:monopoly/graphics/graphics.dart';

import 'dart:core';
import 'dart:html';
import 'dart:math';

Graphics g;

var mouseX, mouseY;

Banker banker;

void main() {
  Element overlay;

  Dom.body(
      overlay = Dom.div("Welcome to Monopoly!")
        ..id = 'overlay'
        ..onClick.listen((_) => overlay.style.display = 'none')
  )..style.background = '#fff';

  var taken = Dom.div('Taken', Dom.hr());
  var available = Dom.div('Available', Dom.hr());

  available.children.addAll(
      ['1#ff0000', '2#00ff00', '3#0000ff', '4#654321', '5#00ffff', '6#ffff00'].map((color) =>
          Dom.div(
              Dom.div(
                  Dom.div()
                    ..style.display = 'block'
                    ..style.background = '#${color.split('#')[1]}',
                  'Player ${color.split('#')[0]}',
              )..className = 'chip chipContainer',
              Dom.hr()
          )
          ..id = 'Player Container $color'
          ..onClick.listen((MouseEvent event) {
            if (event.target is Element){
              Element target = event.target;
              while (!target.id.contains('Player Container')) {
                target = target.parent;
              }
              if (taken.contains(target)) {
                taken.children.remove(target);
                available.children.add(target);
              } else {
                available.children.remove(target);
                taken.children.add(target);
              }
            }
          })
      ).toList()
  );

  Dom.body(
      available,
      taken,
      Dom.div('Continue')..onClick.listen((_) => run(taken.children))
  );

  // Skip to game for testing
   run(available.children);
}

void run(List<Element> players) {
  Dom.body().children.clear();

  // Canvas
  Dom.body(
      (g = new Graphics.blank('board')).canvas
        ..style.position = 'fixed'
        ..style.top = '${100.0 * 20.0 / 2133.0}vw'
        ..style.left = '${100.0 * 15.0 / 1087.0}vh'
  )..style.background = '#222';

  g.setSize((1350.0 / 2133 * window.innerWidth).toInt(), (1050.0 / 1087 * window.innerHeight).toInt());

  banker = new Banker(players.where((div) => div.id.contains('Player Container')).map((div) {
    List<String> data = div.id.split('Player Container ')[1].split('#');
    return new Player(data[0], data[1]);
  }).toList(),
      new DateTime.now().add(new Duration(minutes: 30)));

  banker.run();

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
  banker.update();
}

void render(num delta) {
  banker.render(delta);
}