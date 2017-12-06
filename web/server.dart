
import 'package:monopoly/game/bankerApi.dart';

import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';

import 'package:http_server/http_server.dart';

void main() {
  var staticFiles = new VirtualDirectory('.')
    ..allowDirectoryListing = false;

  final server = new Jaguar(multiThread: true, port: 8081);
  final bankerAPI = new JaguarBankerApi(new BankerApi(null, null));
  server.addApi(bankerAPI);


  runZoned(() {
    HttpServer.bind('0.0.0.0', 7777).then((server) {
      print('Server running');
      server.listen(staticFiles.serveRequest);
    });
  },
      onError: (e, stackTrace) => print('Oh noes! $e $stackTrace'));
}

void run() {

}

void loop(_) {

}

void update() {
}
