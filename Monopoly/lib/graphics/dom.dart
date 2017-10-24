import 'dart:html';

typedef Element OnCall(List);

class VariadicFunction implements Function {
  OnCall _onCall;

  VariadicFunction(this._onCall);

  call() => _onCall([]);

  noSuchMethod(Invocation invocation) {
    final arguments = invocation.positionalArguments;
    if (invocation.positionalArguments[0] is List) {
      return _onCall(arguments[0]);
    } else {
      return _onCall(arguments);
    }
  }
}

class Dom extends Element {

  factory Dom._() => new Element.div();

  static Element _setUpDomChildren(Element e, List<dynamic> children) {
    children.where((c) => c is String).forEach((c) => e.text += c);
    children.where((c) => !(c is String)).forEach(e.append);
    return e;
  }

  static final Function a = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.a(), children) : new Element.a());
  static final Function article = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.article(), children) : new Element.article());
  static final Function aside = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.aside(), children) : new Element.aside());
  static final Function audio = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.audio(), children) : new Element.audio());
  static final Function br = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.br(), children) : new Element.br());
  static final Function canvas = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.canvas(), children) : new Element.canvas());
  static final Function div = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.div(), children) : new Element.div());
  static final Function footer = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.footer(), children) : new Element.footer());
  static final Function header = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.header(), children) : new Element.header());
  static final Function hr = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.hr(), children) : new Element.hr());
  static final Function iframe = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.iframe(), children) : new Element.iframe());
  static final Function img = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.img(), children) : new Element.img());
  static final Function li = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.li(), children) : new Element.li());
  static final Function nav = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.nav(), children) : new Element.nav());
  static final Function ol = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.ol(), children) : new Element.ol());
  static final Function option = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.option(), children) : new Element.option());
  static final Function p = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.p(), children) : new Element.p());
  static final Function pre = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.pre(), children) : new Element.pre());
  static final Function section = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.section(), children) : new Element.section());
  static final Function select = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.select(), children) : new Element.select());
  static final Function span = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.span(), children) : new Element.span());
  static final Function svg = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.svg(), children) : new Element.svg());
  static final Function table = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.table(), children) : new Element.table());
  static final Function td = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.td(), children) : new Element.td());
  static final Function textarea = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.textarea(), children) : new Element.textarea());
  static final Function th = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.th(), children) : new Element.th());
  static final Function tr = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.tr(), children) : new Element.tr());
  static final Function ul = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.ul(), children) : new Element.ul());
  static final Function video = new VariadicFunction(([List<dynamic> children]) => children != null ? _setUpDomChildren(new Element.video(), children) : new Element.video());
  static final Function figure = new VariadicFunction(([List<dynamic> children]) => children != null ?  _setUpDomChildren(document.createElement('FIGURE'), children) : document.createElement('FIGURE'));

  static Element byId(String id) => querySelector('#$id');

  static Element byClass(String id) => querySelector('.$id');

  static BodyElement get body => document.body;
}
