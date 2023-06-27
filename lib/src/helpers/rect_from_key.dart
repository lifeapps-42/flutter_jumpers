import 'package:flutter/material.dart';

Rect? rectFromKey(GlobalKey key) {
  final object = key.currentContext?.findRenderObject();
  final translation = object?.getTransformTo(null).getTranslation();
  final size = object?.semanticBounds.size;

  if (translation != null && size != null) {
    return Rect.fromLTWH(
      translation.x,
      translation.y,
      size.width,
      size.height,
    );
  } else {
    return null;
  }
}
