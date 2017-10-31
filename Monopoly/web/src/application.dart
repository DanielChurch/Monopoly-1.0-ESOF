import 'package:dnd/dnd.dart';
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
  )..style.background = '#222';

  var taken = Dom.div('Taken', Dom.hr()..style.fontSize = '16px')..className = 'left roster';
  var available = Dom.div('Available', Dom.hr()..style.fontSize = '16px')..className = 'right roster';

  available.children.addAll(
      ['1#Rick', '2#Morty', '3#Summer', '4#Beth', '5#Jerry', '6#Jessica'].map((color) =>
          Dom.div(
              Dom.div(
                  Dom.div()
                    ..style.display = 'block',
                  Dom.input('${color.split('#')[1]}')
                    ..id = 'Player'
                    ..style.background = 'inherit'
                    ..style.border = 'inherit'
                    ..style.margin = '15px 0 0 0',
              )..className = 'chip chipContainer',
              Dom.hr()..style.fontSize = '16px'
          )
          ..id = 'Player Container $color'
      ).toList()
  );

  for (Element e in available.children) {
    new Draggable(e, avatarHandler: new AvatarHandler.clone());
  }

  Dropzone takenDrop = new Dropzone(taken)
    ..onDrop.listen((DropzoneEvent e) {
      available.children.remove(e.draggableElement);
      taken.children.add(e.draggableElement);
    });

  Dropzone availableDrop = new Dropzone(available)
    ..onDrop.listen((DropzoneEvent e) {
      taken.children.remove(e.draggableElement);
      available.children.add(e.draggableElement);
    });

  Dom.body(
      available,
      taken,
      Dom.br()..style.padding = '4.6vh, 0, 13.8vh, 0',
      Dom.div(
          Dom.div('Continue')
            ..className = 'continueButton'
            ..onClick.listen((_) => run(taken.children))
      )
        ..style.width = '100%'
        ..style.textAlign = 'center'
  );

  // Skip to game for testing
  if (Uri.base.queryParameters['skipRoster'] == '') {
    run(available.children);
  }
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
    return new Player(data[0], div.querySelector('#Player').value, data[1]);
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