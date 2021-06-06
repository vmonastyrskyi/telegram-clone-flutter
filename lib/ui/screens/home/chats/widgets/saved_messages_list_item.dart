import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/constants/widgets.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/ui/icons/app_icons.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';
import 'package:telegram_clone_mobile/ui/theming/theme_manager.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/saved_messages_list_item_viewmodel.dart';

class SavedMessagesListItem extends StatefulWidget {
  SavedMessagesListItem({Key? key}) : super(key: key);

  @override
  _SavedMessagesListItemState createState() => _SavedMessagesListItemState();
}

class _SavedMessagesListItemState extends State<SavedMessagesListItem> {
  @override
  Widget build(BuildContext context) {
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
        height: WidgetsConstants.kChatListItemHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildLeading(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 14.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _buildTitle(),
                        _buildSubtitle(),
                      ],
                    ),
                    const Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: -14.0,
                      child: Divider(height: 0.5),
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

  Widget _buildLeading() {
    final theme = ThemeManager.of(context).currentTheme;

    return Stack(
      children: <Widget>[
        Selector<SavedMessagesListItemViewModel, String>(
          selector: (context, model) => model.title,
          builder: (context, title, child) {
            return AspectRatio(
              aspectRatio: 1.0,
              child: RoundedAvatar(
                icon: AppIcons.saved_messages,
                backgroundColor: theme.data.accentColor,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Selector<SavedMessagesListItemViewModel, String>(
              selector: (context, model) => model.title,
              builder: (context, chatTitle, child) {
                return Expanded(
                  child: Text(
                    chatTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 239, 239, 248),
                    ),
                  ),
                );
              },
            ),
            Selector<SavedMessagesListItemViewModel, Message>(
              selector: (context, model) => model.lastMessage,
              builder: (context, lastMessage, child) {
                return Container(
                  width: 48.0,
                  margin: const EdgeInsets.only(
                    left: 6.0,
                    bottom: 2.0,
                  ),
                  child: Text(
                    DateFormat('kk:mm').format(lastMessage.createdAt.toDate()),
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 130, 143, 152),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Selector<SavedMessagesListItemViewModel, Message>(
              selector: (context, model) => model.lastMessage,
              builder: (context, lastMessage, child) {
                return Expanded(
                  child: Text(
                    lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 130, 143, 152),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
