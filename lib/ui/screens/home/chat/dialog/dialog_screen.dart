import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/ui/screens/home/chat/shared_widgets/message_input.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/appbar_icon_button.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/dialog_viewmodel.dart';

class DialogArguments {
  DialogArguments({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.dialogUserId,
  });

  final String id;
  final String title;
  final Message lastMessage;
  final String dialogUserId;
}

class DialogScreen extends StatefulWidget {
  const DialogScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen>
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8.0,
        title: Row(
          children: <Widget>[
            RoundedAvatar(
              radius: 21.0,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Selector<DialogViewModel, String>(
                      selector: (context, model) => model.title,
                      builder: (context, title, child) {
                        return Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.headline1!.color,
                          ),
                        );
                      },
                    ),
                    Selector<DialogViewModel, String>(
                      selector: (context, model) =>
                          model.dialogUserOnlineStatus,
                      builder: (context, dialogUserOnlineStatus, child) {
                        return Text(
                          dialogUserOnlineStatus,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: theme.textTheme.headline2!.color,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     final newMessage = MessageData(
      //       text:
      //           'Test messageTest messageTest messageTest messageTest messageTest message',
      //       position: MessagePosition.bottom,
      //       date: 'Apr 29',
      //     );
      //     messages.insert(0, newMessage);
      //     _messagesListKey.currentState!
      //         .insertItem(0, duration: Duration(milliseconds: 2500));
      //
      //     setState(() {
      //       final previousMessage = messages[1];
      //     });
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<DialogViewModel>(
      builder: (context, model, child) {
        return Expanded(
          child: RawScrollbar(
            thumbColor: Colors.black26,
            thickness: 4.0,
            child: ListView.builder(
              key: _messagesListKey,
              controller: model.scrollController,
              itemCount: model.loadedMessages.length,
              reverse: true,
              itemBuilder: (context, index) {
                return Text(model.loadedMessages[index]);
              },
            ),
          ),
        );
      },
    );
  }

  late List<MessageData> messages = [
    MessageData(
      text: 'Bye ma friend!',
      position: MessagePosition.bottom,
      single: true,
      date: '13:49',
    ),
    MessageData(
      text: 'Another text from user',
      position: MessagePosition.bottom,
      owner: true,
      date: '13:49',
    ),
    MessageData(
      text: 'Some text from user',
      position: MessagePosition.center,
      owner: true,
      edited: true,
      date: '13:49',
    ),
    MessageData(
      text: 'Hi body!',
      position: MessagePosition.top,
      owner: true,
      date: '13:49',
    ),
    MessageData(
      text: 'Some big text from another user Some text from another user',
      position: MessagePosition.bottom,
      date: '13:49',
    ),
    MessageData(
      text: 'Hi there',
      position: MessagePosition.top,
      date: '13:49',
    ),
  ];
}

class MessageData {
  MessagePosition position;
  String text;
  String date;
  bool single;
  bool owner;
  bool edited;

  MessageData({
    required this.position,
    required this.text,
    required this.date,
    this.owner = false,
    this.edited = false,
    this.single = false,
  });
}

class MessageListItem extends StatelessWidget {
  final MessageData data;

  const MessageListItem(this.data);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double borderRadius = 12.0;

    return Row(
      mainAxisAlignment:
          data.owner ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
          child: CustomPaint(
            painter: MessagePainter(
              color: data.owner ? theme.primaryColorLight : theme.primaryColor,
              borderRadius: PainterBorderRadius.all(borderRadius),
              position: data.position,
              floating:
                  data.owner ? MessageFloating.right : MessageFloating.left,
              single: data.single,
            ),
            child: Container(
              padding: data.owner
                  ? const EdgeInsets.fromLTRB(10.0, 4.0, 16.0, 4.0)
                  : const EdgeInsets.fromLTRB(16.0, 4.0, 10.0, 4.0),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
                minHeight: 32.0,
              ),
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    child: Text(
                      data.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Text(
                      data.edited ? 'edited ${data.date}' : data.date,
                      style: TextStyle(
                        color: data.owner
                            ? theme.textTheme.headline6!.color
                            : theme.textTheme.headline3!.color,
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
