import 'package:flutter/widgets.dart';
import 'seo_app.dart';

abstract class SeoWidget extends StatelessWidget {
  const SeoWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    SeoInheritedWidget.of(context).update();
    return child;
  }
}

class SeoHead extends SeoWidget {
  const SeoHead({super.key, this.title, this.meta, this.script, required Widget child}) : super(child: child);

  final SeoTitleTag? title;
  final List<SeoMetaTag>? meta;
  final List<SeoScriptTag>? script;
}

class SeoImage extends SeoWidget {
  const SeoImage({super.key, required this.src, required this.alt, required Image child}) : super(child: child);

  final String src;
  final String alt;
}

class SeoLink extends SeoWidget {
  const SeoLink({super.key, required this.href, required Text child}) : super(child: child);

  final String href;
}

class SeoText extends SeoWidget {
  const SeoText({super.key, this.style = SeoTextStyle.p, required Text child}) : super(child: child);

  final SeoTextStyle style;
}

class SeoTitleTag {
  final String title;

  SeoTitleTag(this.title);
}

class SeoMetaTag {
  final String name;
  final String content;

  SeoMetaTag(this.name, this.content);
}

class SeoScriptTag {
  final String content;

  SeoScriptTag(this.content);
}

enum SeoTextStyle { h1, h2, h3, h4, h5, h6, p }