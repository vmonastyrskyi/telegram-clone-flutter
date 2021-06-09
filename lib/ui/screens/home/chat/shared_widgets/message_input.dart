import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:telegram_clone_mobile/ui/icons/app_icons.dart';

class MessageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _isKeyboardVisible = false;
  bool _showSendMessageButton = false;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 125),
      vsync: this,
    )..forward(from: 1.0);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        _isKeyboardVisible ? _showKeyboard() : _hideKeyboard();
      }
    } else if (state == AppLifecycleState.inactive) {
      final bool keyboardVisibility =
          WidgetsBinding.instance!.window.viewInsets.bottom > 0.0;
      setState(() => _isKeyboardVisible = keyboardVisibility);

      if (!keyboardVisibility) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }
  }

  void _showKeyboard() {
    WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) => SystemChannels.textInput.invokeMethod('TextInput.show'));
  }

  void _hideKeyboard() {
    WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // margin: EdgeInsets.only(top: 3),
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      color: theme.primaryColor,
      constraints: BoxConstraints(
        minHeight: 50.0,
        maxHeight: 150.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              AppIcons.stickers,
              size: 24.0,
              color: theme.textTheme.headline3!.color,
            ),
          ),
          Expanded(
            child: AnimatedSize(
              curve: Curves.easeInOutCubic,
              duration: const Duration(milliseconds: 250),
              alignment: Alignment.topCenter,
              vsync: this,
              child: TextField(
                onTap: () {
                  if (!_isKeyboardVisible)
                    setState(() => _isKeyboardVisible = true);
                },
                onChanged: (text) {
                  if (text.trim().isNotEmpty) {
                    if (!_showSendMessageButton) {
                      _controller.reverse().whenComplete(() {
                        setState(() => _showSendMessageButton = true);
                        _controller.forward();
                      });
                    } else
                      _controller.forward();
                  } else {
                    if (_showSendMessageButton)
                      _controller.reverse().whenComplete(() {
                        setState(() => _showSendMessageButton = false);
                        _controller.forward();
                      });
                    else
                      _controller.forward();
                  }
                },
                autocorrect: true,
                cursorColor: theme.accentColor,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                  color: theme.textTheme.headline1!.color,
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Message',
                  hintStyle: TextStyle(
                    color: theme.textTheme.headline3!.color,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          Builder(builder: (_) {
            if (_showSendMessageButton)
              return _SendMessageButton(controller: _controller);

            return _AttachFileAndMicButtons(animation: _controller);
          }),
        ],
      ),
    );
  }
}

class _SendMessageButton extends AnimatedWidget {
  final AnimationController controller;

  _SendMessageButton({
    Key? key,
    required this.controller,
  })   : _scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutCubic,
          ),
        ),
        super(key: key, listenable: controller);

  final Animation<double> _scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform.scale(
          scale: _scale.value,
          child: _buildSendMessageButton(context),
        ),
      ],
    );
  }

  Widget _buildSendMessageButton(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        AppIcons.send,
        size: 21.0,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}

class _AttachFileAndMicButtons extends AnimatedWidget {
  final AnimationController animation;

  _AttachFileAndMicButtons({
    Key? key,
    required this.animation,
  })   : _scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ),
        ),
        _position = Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ),
        ),
        super(key: key, listenable: animation);

  final Animation<double> _scale;
  final Animation<Offset> _position;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SlideTransition(
          position: _position,
          child: ScaleTransition(
            scale: _scale,
            child: _buildAttachFileButton(context),
          ),
        ),
        ScaleTransition(
          scale: _scale,
          child: _buildMicButton(context),
        ),
      ],
    );
  }

  Widget _buildAttachFileButton(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        AppIcons.attach_file,
        size: 24.0,
        color: Theme.of(context).textTheme.headline3!.color,
      ),
    );
  }

  Widget _buildMicButton(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        AppIcons.mic,
        size: 24.0,
        color: Theme.of(context).textTheme.headline3!.color,
      ),
    );
  }
}
