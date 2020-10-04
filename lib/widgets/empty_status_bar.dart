import 'package:flutter/material.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
