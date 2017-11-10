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
Element overlay;

void main() {
  Dom.body()..style.background = '#222';

  Dom.body(
      overlay = Dom.div()
        ..id = 'overlay'
        ..onClick.listen((_) => overlay.style.display = 'none')
  )..style.background = '#222';

  print('window.innerWidth ${window.innerWidth}, window.innerHeight ${window.innerHeight}');

  var taken = Dom.div('Taken', Dom.hr()..style.fontSize = '16px')..className = 'left roster';
  var available = Dom.div('Available', Dom.hr()..style.fontSize = '16px')..className = 'right roster';

  available.children.addAll(
      ['0#Rick', '1#Morty', '2#Summer', '3#Beth', '4#Jerry', '5#Jessica'].map((color) =>
          Dom.div(
              Dom.div(
                  Dom.div(
                      Dom.img()
                        ..src = 'res/images/${color.split('#')[0]}.png'
                        ..style.height = '100%'
                        ..style.position = 'absolute'
                        ..style.bottom = '0'
                        ..style.margin = 'auto'
                  )
                    ..style.display = 'block'
                    ..style.background = 'url(res/images/charBackround_${color.split('#')[0]}.png)'
                    ..style.backgroundSize = 'cover'
                    ..style.backgroundRepeat = 'no-repeat'
                    ..style.backgroundPosition = 'center center'
                    ..style.width = '100%'
                    ..style.borderRadius = '0'
                    ..style.position = 'absolute',
                  Dom.input('${color.split('#')[1]}')
                    ..id = 'Player'
                    ..style.opacity = '0.8'
                    ..style.color = '#fff'
                    ..style.background = '#000'
                    ..style.border = 'inherit'
                    ..style.margin = '${15.0 * 100 / 1087}vh 0 0 0'
                    ..style.zIndex = '3'
                    ..style.left = '${100.0 * 55 / 2133}vw'
                    ..style.position = 'absolute'
                    ..style.textAlign = 'center',
              )..className = 'chip chipContainer',
              Dom.hr()..style.fontSize = '16px'..style.opacity = '0'
          )
          ..id = 'Player Container $color'
      ).toList()
  );

  available.children.forEach((child) => new Draggable(child, avatarHandler: new AvatarHandler.clone()));

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
            ..onClick.listen((_) {
              if (taken.children.every((child) => !child.id.contains('Player Container'))) {
                overlay
                  ..text = 'Please select at least one player.'
                  ..style.display = 'block';
              } else {
                // Dispose of dropzones
                takenDrop.destroy();
                availableDrop.destroy();

                run(taken.children);
              }
            })
      )
        ..style.width = '100%'
        ..style.textAlign = 'center'
  );

  // Skip to game for testing
  if (Uri.base.queryParameters['skipRoster'] != null) {
    run(available.children);
  }
}

void run(List<Element> players) {
  Dom.body().children.clear();
  
  // Canvas
  Dom.body(
    Dom.div(
      (g = new Graphics.blank('board')).canvas
        ..id = 'gameBoard'
        ..style.display = 'block'
//        ..style.position = 'fixed'
        ..style.top = '${100.0 * 20.0 / 2133.0}vw'
        ..style.margin = 'auto' // 15
        ..style.border = '5px solid #c40'
    )..style.width = '65%'
  )..style.background = '#222';

  g.setSize((1050).toInt(), (1050).toInt());

  banker = new Banker(players.where((div) => div.id.contains('Player Container')).map((div) {
    List<String> data = div.id.split('Player Container ')[1].split('#');
    return new Player(data[0], (div.querySelector('#Player') as InputElement).value);
  }).toList(),
      new DateTime.now().add(new Duration(minutes: 30)), g);

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