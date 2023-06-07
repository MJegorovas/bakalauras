import 'dart:async';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter_seo/seo_widget.dart';
import 'debouncer.dart';

class SeoApp extends StatefulWidget {
  const SeoApp({super.key, required this.child});

  final Widget child;

  @override
  State createState() => _SeoAppState();
}

class _SeoAppState extends State<SeoApp> {

  final StreamController<void> _controller = StreamController();
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    document.body!.appendHtml("<div id=\"seo\">");
    _controller.stream.listen((_) => _debouncer(update));
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SeoInheritedWidget(controller: _controller, child: widget.child);
  }

  void update() {
    var sb = StringBuffer();
    void visitor(Element element) {
      switch (element.widget.runtimeType) {
        case SeoHead:
          var widget = (element.widget as SeoHead);
          if (widget.title != null) {
            document.title = widget.title!.title;
          }

          var head = StringBuffer();
          if (widget.meta != null) {
            for (final tag in widget.meta!) {
              head.write("<meta name=\"${tag.name}\" content=\"${tag.content}\" seo>");
            }
          }

          if (widget.script != null) {
            for (final tag in widget.script!) {
              head.write("<script type=\"application/ld+json\" seo>{${tag.content}}</script>");
            }
          }

          for (final child in document.head!.children) {
            if (child.hasAttribute("seo")) child.remove();
          }
          document.head!.appendHtml(head.toString(), validator: NodeValidatorBuilder()..allowCustomElement("meta", attributes: ["name", "content", "seo"]));

          element.visitChildren(visitor);
          break;
        case SeoText:
          var widget = (element.widget as SeoText);
          var data = (widget.child as Text).data;
          sb.write("<${widget.style.name}>$data</${widget.style.name}>");
          break;
        case SeoLink:
          var widget = element.widget as SeoLink;
          var data = (widget.child as Text).data;
          sb.write("<a href=\"${widget.href}\">$data</a>");
          break;
        case SeoImage:
          var widget = element.widget as SeoImage;
          var image = widget.child as Image;
          sb.write("<noscript><img src=\"${widget.src}\" alt=\"${widget.alt}\" width=\"${image.width}\" height=\"${image.height}\"></noscript>");
          break;
        default:
          element.visitChildren(visitor);
          break;
      }

      querySelector("#seo")!.setInnerHtml(
          sb.toString(),
          validator: NodeValidatorBuilder()
            ..allowHtml5(uriPolicy: _AllowAllUriPolicy())
            ..allowCustomElement("noscript")
      );
    }
    context.visitChildElements(visitor);
  }
}

class _AllowAllUriPolicy implements UriPolicy {
  @override
  bool allowsUri(String uri) => true;
}

class SeoInheritedWidget extends InheritedWidget {
  const SeoInheritedWidget({super.key, required StreamController<void> controller, required super.child}) : _controller = controller;

  final StreamController<void> _controller;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static SeoInheritedWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SeoInheritedWidget>();
  }

  static SeoInheritedWidget of(BuildContext context) {
    final SeoInheritedWidget? result = maybeOf(context);
    assert(result != null, 'No SeoInheritedWidget found in context');
    return result!;
  }

  void update() {
    _controller.add(null);
  }
}