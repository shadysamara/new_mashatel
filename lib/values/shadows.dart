/*
*  shadows.dart
*  DhabayehAlEmarat
*
*  Created by [Author].
*  Copyright © 2018 [Company]. All rights reserved.
    */

import 'package:flutter/rendering.dart';


class Shadows {
  static const BoxShadow primaryShadow = BoxShadow(
    color: Color.fromARGB(41, 163, 163, 163),
    offset: Offset(0, 2),
    blurRadius: 3,
  );
  static const BoxShadow secondaryShadow = BoxShadow(
    color: Color.fromARGB(20, 0, 0, 0),
    offset: Offset(0, 2),
    blurRadius: 48,
  );
}