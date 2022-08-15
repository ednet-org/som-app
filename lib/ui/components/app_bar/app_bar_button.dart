import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatefulWidget {
  AppBarButton({
    required this.beamer,
    required this.uri,
    required this.child,
  });

  final GlobalKey<BeamerState> beamer;
  final String uri;
  final Widget child;

  @override
  _AppBarButtonState createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<AppBarButton> {
  void _setStateListener() => setState(() {});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => widget
        .beamer.currentState?.routerDelegate
        .addListener(_setStateListener));
  }

  @override
  Widget build(BuildContext context) {
    final path = (context.currentBeamLocation.state as BeamState).uri.path;

    return ElevatedButton(
      onPressed: () =>
          widget.beamer.currentState?.routerDelegate.beamToNamed(widget.uri),
      style: ButtonStyle(
        backgroundColor: path.contains(widget.uri)
            ? MaterialStateProperty.all<Color>(Colors.green)
            : MaterialStateProperty.all<Color>(Colors.blue),
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.beamer.currentState?.routerDelegate
        .removeListener(_setStateListener);
    super.dispose();
  }
}
