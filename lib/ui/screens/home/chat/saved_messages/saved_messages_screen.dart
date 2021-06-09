import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/ui/icons/app_icons.dart';
import 'package:telegram_clone_mobile/ui/screens/home/chat/shared_widgets/message_input.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/appbar_icon_button.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';
import 'package:telegram_clone_mobile/ui/theming/theme_manager.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/saved_messages_viewmodel.dart';

class SavedMessagesScreen extends StatefulWidget {
  const SavedMessagesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SavedMessagesScreenState();
}

class _SavedMessagesScreenState extends State<SavedMessagesScreen>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _messagesListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.of(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8.0,
        title: Row(
          children: <Widget>[
            RoundedAvatar(
              icon: AppIcons.saved_messages,
              backgroundColor: theme.data.accentColor,
              radius: 21.0,
              iconSize: 21.0,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Selector<SavedMessagesViewModel, String>(
                      selector: (context, model) => model.title,
                      builder: (context, title, child) {
                        return Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: theme.data.textTheme.headline1!.color,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          AppBarIconButton(
            onTap: () {},
            icon: Icons.more_vert,
            iconSize: 24.0,
            iconColor: Theme.of(context).textTheme.headline1!.color!,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background-white.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              _buildMessageList(),
              MessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<SavedMessagesViewModel>(
      builder: (context, model, child) {
        return Expanded(
          child: AnimatedList(
            key: _messagesListKey,
            initialItemCount: model.messages.length,
            reverse: true,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                axisAlignment: -1.0,
                sizeFactor: animation.drive(Tween<double>(begin: 0.0, end: 1.0)
                    .chain(CurveTween(curve: Curves.easeInOutCubic))),
                // child: MessageListItem(model.messages[index]),
                child: SizedBox.shrink(),
              );
            },
          ),
        );
      },
    );
  }
}

class PainterBorderRadius {
  final double topLeft;
  final double topRight;
  final double bottomRight;
  final double bottomLeft;

  const PainterBorderRadius({
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
    required this.topLeft,
  });

  const PainterBorderRadius.all(double value)
      : topLeft = value,
        topRight = value,
        bottomRight = value,
        bottomLeft = value;
}

enum MessagePosition {
  top,
  center,
  bottom,
}

enum MessageFloating {
  left,
  right,
}

class MessagePainter extends CustomPainter {
  final Color color;
  final PainterBorderRadius borderRadius;
  final MessagePosition position;
  final MessageFloating floating;
  final bool single;

  MessagePainter({
    required this.color,
    required this.borderRadius,
    required this.position,
    required this.floating,
    required this.single,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final offset = 5.0;

    switch (position) {
      case MessagePosition.top:
        // Top Left Border
        path.moveTo(offset, size.height - borderRadius.bottomLeft);
        path.cubicTo(offset, size.height * 0.5, offset, size.height * 0.5,
            offset, borderRadius.topLeft);

        // Top Right Border
        path.quadraticBezierTo(offset, 0.0, offset + borderRadius.topLeft, 0.0);
        path.lineTo(size.width - borderRadius.topRight, 0.0);
        path.quadraticBezierTo(
            size.width, 0.0, size.width, borderRadius.topRight);

        // Bottom Right Border
        path.cubicTo(
            size.width,
            size.height * 0.5,
            size.width,
            size.height * 0.5,
            size.width,
            size.height - borderRadius.bottomRight);
        path.quadraticBezierTo(size.width, size.height,
            size.width - borderRadius.bottomRight, size.height);

        // Bottom Left Border
        path.lineTo(offset + (borderRadius.bottomLeft / 3.0), size.height);
        path.quadraticBezierTo(offset, size.height, offset,
            size.height - (borderRadius.bottomLeft / 3.0));
        break;
      case MessagePosition.center:
        // Top Left Border
        path.moveTo(offset, size.height - (borderRadius.bottomLeft / 3.0));
        path.cubicTo(offset, size.height * 0.5, offset, size.height * 0.5,
            offset, (borderRadius.topLeft / 3.0));

        // Top Right Border
        path.quadraticBezierTo(
            offset, 0.0, (borderRadius.topLeft / 3.0) + offset, 0.0);
        path.lineTo(size.width - borderRadius.topRight, 0.0);
        path.quadraticBezierTo(
            size.width, 0.0, size.width, borderRadius.topRight);

        // Bottom Right Border
        path.cubicTo(
            size.width,
            size.height * 0.5,
            size.width,
            size.height * 0.5,
            size.width,
            size.height - borderRadius.bottomRight);
        path.quadraticBezierTo(size.width, size.height,
            size.width - borderRadius.bottomRight, size.height);

        // Bottom Left Border
        path.lineTo(offset + (borderRadius.bottomLeft / 3.0), size.height);
        path.quadraticBezierTo(offset, size.height, offset,
            size.height - (borderRadius.bottomLeft / 3.0));
        break;
      case MessagePosition.bottom:
        // Bottom Left Border
        path.moveTo(0.0, size.height - 1.0);
        path.quadraticBezierTo(offset, size.height - 2.0, offset,
            size.height - (borderRadius.bottomLeft / 3.0) - offset);

        // Top Left Border
        path.cubicTo(
            offset,
            size.height * 0.5,
            offset,
            size.height * 0.5,
            offset,
            (single ? borderRadius.topLeft : borderRadius.topLeft / 3.0));
        path.quadraticBezierTo(
            offset,
            0.0,
            (single ? borderRadius.topLeft : borderRadius.topLeft / 3.0) +
                offset,
            0.0);

        // Top Right Border
        path.lineTo(size.width - borderRadius.topRight, 0.0);
        path.quadraticBezierTo(
            size.width, 0.0, size.width, borderRadius.topRight);

        // Bottom Right Border
        path.cubicTo(
            size.width,
            size.height * 0.5,
            size.width,
            size.height * 0.5,
            size.width,
            size.height - borderRadius.bottomRight);
        path.quadraticBezierTo(size.width, size.height,
            size.width - borderRadius.bottomRight, size.height);

        path.lineTo(0.0, size.height);
        break;
    }

    if (floating == MessageFloating.left) {
      canvas.translate(0.0, 0.0);
      canvas.scale(1.0, 1.0);
    } else if (floating == MessageFloating.right) {
      canvas.translate(size.width, 0.0);
      canvas.scale(-1.0, 1.0);
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
