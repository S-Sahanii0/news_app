import 'package:flutter/material.dart';
import '../config/theme/theme.dart';

class AppFloatingActionButton extends StatefulWidget {
  const AppFloatingActionButton({Key? key, required this.scaffoldKey})
      : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _AppFloatingActionButtonState createState() =>
      _AppFloatingActionButtonState();
}

class _AppFloatingActionButtonState extends State<AppFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.scaffoldKey.currentState!.openEndDrawer();
      },
      child: const Image(
        image: AppIcons.floating,
      ),
    );
  }
}
