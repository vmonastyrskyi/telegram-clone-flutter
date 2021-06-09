import 'package:flutter/material.dart';

class Modal extends StatefulWidget {
  const Modal({
    Key? key,
    required this.title,
    this.titlePadding = const EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
    required this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 6.0, 24.0, 12.0),
    required this.actions,
    this.actionsPadding = const EdgeInsets.fromLTRB(24.0, 12.0, 8.0, 2.0),
  }) : super(key: key);

  final String title;
  final EdgeInsetsGeometry titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final List<Widget> actions;
  final EdgeInsetsGeometry actionsPadding;

  @override
  _ModalState createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  static final double _kElevation = 3.0;
  static final double _kTitleFontSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Material(
          elevation: _kElevation,
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTitle(),
              _buildContent(),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: widget.titlePadding,
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: _kTitleFontSize,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.headline1!.color,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: widget.contentPadding,
      child: widget.content,
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: widget.actionsPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.actions,
      ),
    );
  }
}
