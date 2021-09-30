import 'package:flutter/material.dart';

class TappableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const TappableAppBar({Key key, this.onTap, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
