// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BankerApi
// **************************************************************************

class JaguarBankerApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: 'roll'),
    const Post(path: 'endAuction'),
    const Post(path: 'buy'),
    const Post(path: 'declineProperty'),
    const Post(path: 'mortageProperty'),
    const Post(path: 'payMortage'),
    const Post(path: 'tradeMortgage'),
    const Post(path: 'tradeProperty'),
    const Post(path: 'manageHouses'),
    const Post(path: 'endAction'),
    const Post(path: 'payMortgageImmediately'),
    const Post(path: 'payMortgageLater'),
    const Post(path: 'buyHoue'),
    const Post(path: 'sellHouse'),
    const Post(path: 'updatePlayers')
  ];

  final BankerApi _internal;

  JaguarBankerApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/BankerApi';
    bool match = false;

//Handler for rollDice
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.rollDice, routes[0]);
    }

//Handler for endAuction
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.endAuction, routes[1]);
    }

//Handler for buyProperty
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.buyProperty, routes[2]);
    }

//Handler for declineProperty
    match = routes[3].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.declineProperty, routes[3]);
    }

//Handler for mortgageProperty
    match = routes[4].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, _internal.mortgageProperty, routes[4]);
    }

//Handler for payMortgage
    match = routes[5].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.payMortgage, routes[5]);
    }

//Handler for tradeMortgage
    match = routes[6].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.tradeMortgage, routes[6]);
    }

//Handler for tradeProperty
    match = routes[7].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.tradeProperty, routes[7]);
    }

//Handler for manageHouses
    match = routes[8].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.manageHouses, routes[8]);
    }

//Handler for endAction
    match = routes[9].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.endAction, routes[9]);
    }

//Handler for payMortgageImmediately
    match = routes[10].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, _internal.payMortgageImmediately, routes[10]);
    }

//Handler for payMortgageLater
    match = routes[11].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, _internal.payMortgageLater, routes[11]);
    }

//Handler for buyHouse
    match = routes[12].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.buyHouse, routes[12]);
    }

//Handler for sellHouse
    match = routes[13].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.sellHouse, routes[13]);
    }

//Handler for updatePlayers
    match = routes[14].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.updatePlayers, routes[14]);
    }

    return null;
  }
}
