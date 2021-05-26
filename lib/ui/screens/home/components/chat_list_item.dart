import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'body.dart';

class ChatListItem extends StatelessWidget {
  final ChatData data;

  ChatListItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   SlideLeftWithFadeRoute(
        //     builder: (context) => ChatScreen(data: data),
        //   ),
        // );
      },
      child: SizedBox(
        height: 72,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Leading
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Leading(data: data, theme: theme),
            ),
            // Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Title(data: data),
                        Subtitle(data: data, theme: theme),
                      ],
                    ),
                    // Divider
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: -14,
                      child: Divider(
                        height: 1,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Leading extends StatelessWidget {
  const Leading({
    Key? key,
    required this.data,
    required this.theme,
  }) : super(key: key);

  final ChatData data;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Avatar
        AspectRatio(
          aspectRatio: 1.0,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(
              data.image,
            ),
          ),
        ),
        // Online Status
        if (data.online)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 92, 194, 69),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ChatData data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 239, 239, 248),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 6,
              ),
              child: Text(
                data.lastMessageDate,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 130, 143, 152),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Subtitle extends StatelessWidget {
  const Subtitle({
    Key? key,
    required this.data,
    required this.theme,
  }) : super(key: key);

  final ChatData data;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                data.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 130, 143, 152),
                ),
              ),
            ),
            if (data.nonReadCounter > 0)
              Container(
                width: 48,
                margin: const EdgeInsets.only(
                  left: 6,
                ),
                child: UnconstrainedBox(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    constraints: BoxConstraints(
                      minWidth: 24,
                      maxWidth: 48,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        const Radius.circular(24),
                      ),
                      color: theme.accentColor,
                    ),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Text(
                        data.nonReadCounter.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
