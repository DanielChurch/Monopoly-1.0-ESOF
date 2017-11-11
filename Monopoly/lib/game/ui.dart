import 'dart:html';

import 'package:monopoly/graphics/dom.dart';

import 'banker.dart';
import 'dice.dart';
import 'player.dart';

class UserInterface {

  /* Functions added
  Land on Property- (Buy, Decline)
  Mortgaging- (Mortgaging_Property)
  Trade- (Trade_Mortgage, Trade_Property)
   */

  /* to be added
  Auction- (Bid_1, Bid_5, Bid_10, Bid_20, Bid_50, Bid_100, Bid_500)
  Manage Property- (Buy_House,Buy_Hotel)
  Selling- (Sell_House, Sell_Hotel, Sell_Property)
   */

  static String highlightColor = '';
  static String defaultColor = '';

  static Element get buyPropertyOverlay {
    Element overlay;
    return overlay = Dom.div(
      _buyPropertyButton..onMouseDown.listen((_) => overlay..style.display = 'none'),
      _declinePropertyButton..onMouseDown.listen((_) => overlay..style.display = 'none'),
    )
      ..id = 'overlay'
      ..className = 'propertyOverlay'
      ..style.color = '#fff'
      ..style.display = 'none'
      ..style.zIndex = '50';
  }

  static Element get _buyPropertyButton {
    Element div;
    return div = Dom.div('Buy Property')
        ..onMouseDown.listen((_) {
          // Buy property, may be better to let banker handle this.
        })
        ..onMouseEnter.listen((_) => div.style.background = highlightColor)
        ..onMouseLeave.listen((_) => div.style.background = defaultColor);
  }

  static Element get _declinePropertyButton {
    Element div;
    return div = Dom.div('Decline Property')
      ..onMouseDown.listen((_) {
        // Buy property, may be better to let banker handle this.
      })
      ..onMouseEnter.listen((_) => div.style.background = highlightColor)
      ..onMouseLeave.listen((_) => div.style.background = defaultColor);
  }

  static Element get mortgagePropertyButton => null;

  static Element get tradeMortgageButton => null;

  static Element get tradePropertyButton => null;

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
        Dom.div('Tooltip Line 3')..id = 'properties'
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
      ..style.left = '78.53vw'
      ..style.top = '73.6vh'
      ..style.zIndex = '20';

    Banker.dice.add(new Dice(60.0, 600.0, 0.0, container: section));
    Banker.dice.add(new Dice(-60.0, 600.0, 0.0, container: section));

    return section;
  }

  static Element renderAllCards(List<Player> players) {
    int index = 0;

    return Dom.div(
        players.map((player) => renderCard(players, player, index++)).toList()
    )
      ..className = 'cardBackground'
      ..style.width = '${10.5 * (index > 2 ? 3 : index)}vw'
      ..style.height = '${28.5 * (index / 3).ceil()}vh';
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
          Dom.div('\$${player.balance}'),
          Dom.div('Properties'),
          Dom.div('Line1'),
        )
          ..id = 'properties'
          ..className = 'cardContainer'
          ..style.height = '${76.0 * 100 / 1087}vh'
          ..style.fontSize = '${16.0 * 100 / 1087}vh'
          ..style.textOverflow = 'clip'
          ..style.overflow = 'hidden'
    )
      ..onMouseEnter.listen((_) {
        Banker.tooltip.style.visibility = 'visible';
        Banker.tooltip.children.where((child) => child.id == 'name').toList()[0].text = '${player.name}';
        Banker.tooltip.children.where((child) => child.id == 'money').toList()[0].text = '\$696969669';
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
      ..style.left = '${10.38 * (index % 3) + 65.64}vw' // 9.38
      ..style.top = '${28 * (index ~/ 3) + 1.3 + 2.4}vh' // 23
      ..style.height = '${280 / 1087 * 100}vh'
      ..style.width = '${205 * 100 / 2133}vw';
  }

}