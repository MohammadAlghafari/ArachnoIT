import 'package:flutter/widgets.dart';

class RecreateWidget extends StatefulWidget {
  final Widget child;
  final bool shouldRecreate;

  const RecreateWidget({
    Key key,
    this.child,
    this.shouldRecreate,
  }) : super(key: key);

  @override
  _RecreateWidgetState createState() => _RecreateWidgetState();
}

class _RecreateWidgetState extends State<RecreateWidget> {
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return _RecreateInheritedWidget(
      key: widget.shouldRecreate ? UniqueKey() : _key,
      state: this,
      child: widget.child,
    );
  }
}

class _RecreateInheritedWidget extends InheritedWidget {
  final _RecreateWidgetState state;

  _RecreateInheritedWidget({
    Key key,
    this.state,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
