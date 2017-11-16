import 'dart:html';

import 'package:monopoly/graphics/dom.dart';

import 'banker.dart';
import 'dice.dart';
import 'player.dart';

class UserInterface {

  static String highlightColor = '#fff';
  static String defaultColor = '#aaa';

  static Element get buyPropertyOverlay {
    Element propertyOverlay = querySelector('.propertyOverlay');
    if (propertyOverlay == null) {
      return Dom.div(
        _buyPropertyButton,
        _declinePropertyButton,
      )
        ..id = 'overlay'
        ..className = 'propertyOverlay'
        ..style.color = '#fff'
        ..style.display = 'none'
        ..style.zIndex = '50';
    } else {
      return propertyOverlay;
    }
  }

  static Element get payImmediatelyOverlay {
    Element propertyOverlay = querySelector('.payImmediatelyOverlay');
    if (propertyOverlay == null) {
      return Dom.div(
        'Choose payment plan',
        _payImmediatelyButton,
        _doNotPayImmediatelyButton,
      )
        ..id = 'overlay'
        ..className = 'payImmediatelyOverlay'
        ..style.color = '#fff'
        ..style.display = 'none'
        ..style.zIndex = '50';
    } else {
      return propertyOverlay;
    }
  }

  static Element get manageHousesOverlay {
    Element propertyOverlay = querySelector('.manageHousesOverlay');
    if (propertyOverlay == null) {
      return Dom.div(
        _buyHouseButton,
        _sellHouseButton,
      )
        ..id = 'overlay'
        ..className = 'manageHousesOverlay'
        ..style.color = '#fff'
        ..style.display = 'none'
        ..style.zIndex = '50';
    } else {
      return propertyOverlay;
    }
  }

  static Element _renderButton(String text) {
    Element div;
    return div = Dom.div(text)
      ..onMouseEnter.listen((_) => div.style.color = highlightColor)
      ..onMouseLeave.listen((_) => div.style.color = defaultColor)
      ..style.color = defaultColor;
  }

  static Element get _payImmediatelyButton {
    return _renderButton('Pay Immediately');
  }

  static Element get _doNotPayImmediatelyButton {
    return _renderButton('Pay Later');
  }

  static Element get _buyPropertyButton {
    return _renderButton('Buy Property');
  }

  static Element get _declinePropertyButton {
    return _renderButton('Decline Property');
  }

  static Element get _buyHouseButton {
    return _renderButton('Buy House');
  }

  static Element get _sellHouseButton {
    return _renderButton('Sell House');
  }

  static Element get otherButtonGroup {
    return Dom.div(
      finishAuctionButton,
      mortgagePropertyButton,
      payMortgageButton,
      tradeMortgageButton,
      tradePropertyButton,
      manageHousesButton,
    )
      ..className = 'cardBackground'
      ..style.top = '31vw'
      ..style.width = '${10.6 * 3}vw'
      ..style.height = '${36}vh';

  }

  static Element get mortgagePropertyButton {
    Element auctionButton = querySelector('#mortgagePropertyButton');
    if (auctionButton == null) {
      return Dom.div("Mortgage Property")
        ..id = 'mortgagePropertyButton'
        ..className = 'genericButton';
    } else {
      return auctionButton;
    }
  }

  static Element get payMortgageButton {
    Element auctionButton = querySelector('#payMortgageButton');
    if (auctionButton == null) {
      return Dom.div("Pay Mortgage")
        ..id = 'payMortgageButton'
        ..className = 'genericButton';
    } else {
      return auctionButton;
    }
  }

  static Element get tradeMortgageButton {
    Element auctionButton = querySelector('#tradeMortgageButton');
    if (auctionButton == null) {
      return Dom.div("Trade Mortgage")
        ..id = 'tradeMortgageButton'
        ..className = 'genericButton';
    } else {
      return auctionButton;
    }
  }

  static Element get tradePropertyButton {
    Element auctionButton = querySelector('#tradePropertyButton');
    if (auctionButton == null) {
      return Dom.div("Trade Property")
        ..id = 'tradePropertyButton'
        ..className = 'genericButton';
    } else {
      return auctionButton;
    }
  }

  static Element get finishAuctionButton {
    Element auctionButton = querySelector('#auctionButton');
    if (auctionButton == null) {
      return Dom.div("End Auction")
        ..id = 'auctionButton'
        ..className = 'genericButton';
    } else {
      return auctionButton;
    }
  }

  static Element get manageHousesButton {
    Element auctionButton = querySelector('#manageHousesButton');
    if (auctionButton == null) {
      return Dom.div("Manage Houses")
        ..id = 'manageHousesButton'
        ..className = 'genericButton';
    } else {
      return auctionButton;
    }
  }

  static Element renderOverlay() {
    Element overlay;
    overlay = Dom.div()
      ..onClick.listen((_) => overlay.style.display = 'none')
      ..id = 'overlay'
      ..style.color = '#fff'
      ..style.display = 'none'
      ..style.zIndex = '50';

    return overlay;
  }

  static Element renderTooltip() {
    Element tooltip;
    //Tooltip
    tooltip = Dom.span(
        Dom.div()..id = 'name',
        Dom.p(),
        Dom.div()..id = 'money',
        Dom.p(),
        Dom.div('')..id = 'properties'
    )
      ..className = 'tooltip tooltiptext'
      ..style.width = '200px';

    window.onMouseMove.listen((MouseEvent me) {
      Banker.tooltip
        ..style.left = '${me.client.x - 100}px' // 4.69
        ..style.top = '${me.client.y + 20}px';
    });

    return tooltip;
  }

  static Element renderDice() {
    // Dice
    Element section = Dom.div(Dom.div()..className = 'cubeContainer')
      ..className = 'cubeContainer'
      ..style.position = 'fixed'
      ..style.left = '30.53vw'
      ..style.top = '77.6vh'
      ..style.zIndex = '20';

    Banker.dice.add(new Dice(5.519779208831646734130634774609, 55.19779208831646734130634774609, 0.0, container: section));
    Banker.dice.add(new Dice(-5.519779208831646734130634774609, 55.19779208831646734130634774609, 0.0, container: section));

    return section;
  }

  static Element renderAllCards(List<Player> players) {
    int index = 0;

    return Dom.div(
        players.map((player) => renderCard(players, player, index++)).toList()
    )
      ..className = 'cardBackground'
      ..style.width = '${10.6 * 3}vw'
      ..style.height = '${28.5 * 2}vh';
  }

  static Element renderCard(List<Player> players, Player player, int index) {
    return Dom.div(
        Dom.div(
            Dom.img()
              ..src = 'res/images/${player.id}.png'
              ..style.width = '7.03vw'
              ..style.height = '13.8vh'
              ..style.position = 'absolute'
              ..style.bottom = '0'
              ..style.right = '.94vw'
              ..style.margin = 'auto'
        )
          ..className = 'cardImage'
          ..style.background = 'url(res/images/charBackround_${player.id}.png)' // #${player.token}
          ..style.height = '18.4vh'
          ..style.backgroundSize = 'cover'
          ..style.backgroundRepeat = 'no-repeat'
          ..style.backgroundPosition = 'center center',
        Dom.div(
          Dom.div('${player.name}'),
          Dom.div('${player.balance} Schmeckles'),
          Dom.input('${player.bid} Schmeckles')
            ..style.background = '#222'
            ..style.textAlign = 'center'
            ..style.color = '#fff'
            ..style.border = 'inherit'
            ..style.fontSize = '1.2951057957681692732290708371665vh'
            ..style.height = '1.5698252069917203311867525298988vh',
        )
          ..id = 'properties'
          ..className = 'cardContainer ${player.id}'
          ..style.height = '${76.0 * 100 / 1087}vh'
          ..style.fontSize = '${16.0 * 100 / 1087}vh'
          ..style.textOverflow = 'clip'
          ..style.overflow = 'hidden'
    )
      ..onMouseEnter.listen((_) {
        Banker.tooltip.style.visibility = 'visible';
        Banker.tooltip.children.where((child) => child.id == 'name').toList()[0].text = '${player.name}';
        Banker.tooltip.children.where((child) => child.id == 'money').toList()[0].text = '${player.balance} Schmeckles';
        Banker.tooltip.children.where((child) => child.id == 'properties').toList()[0].text = '';
        player.tokenScale = 3;
        Banker.redrawCanvas(players);
      })
      ..onMouseLeave.listen((_) {
        Banker.tooltip.style.visibility = 'hidden';
        player.tokenScale = 1;
        Banker.redrawCanvas(players);
      })
      ..id = 'selectedCardContainer'
      ..style.position = 'fixed'
      ..className = 'card  ${player.id} ${player.id == '0' ? 'selected' : ''}'
      ..style.left = '${10.38 * (index % 3) + 65.64}vw'
      ..style.top = '${28 * (index ~/ 3) + 1.3 + 2.4}vh'
      ..style.height = '${280 / 1087 * 100}vh'
      ..style.width = '${205 * 100 / 2133}vw';
  }

  static void updateCards(List players) {
    querySelectorAll('#selectedCardContainer').forEach((Element element) {
      Element properties = element.querySelector('#properties');
      players.forEach((player) {
        if (properties.className.contains(player.id)) {
          properties.children[1].text = '${player.balance} Schmeckles';
          (properties.children[2] as InputElement).value = '${player.bid} Schmeckles';
        }
      });
    });
  }

}