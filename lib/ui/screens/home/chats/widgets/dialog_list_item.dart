import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/constants/widgets.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';
import 'package:telegram_clone_mobile/ui/theming/theme_manager.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/dialog_list_item_viewmodel.dart';

class DialogListItem extends StatefulWidget {
  DialogListItem({Key? key}) : super(key: key);

  @override
  _DialogListItemState createState() => _DialogListItemState();
}

class _DialogListItemState extends State<DialogListItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<DialogListItemViewModel>().listenOnUserChanged();
      context.read<DialogListItemViewModel>().listenOnChatChanged();
    });
  }

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
        Selector<DialogListItemViewModel, String>(
          selector: (context, model) => model.title,
          builder: (context, title, child) {
            return AspectRatio(
              aspectRatio: 1.0,
              child: RoundedAvatar(
                text: title,
                backgroundColor: theme.data.accentColor,
              ),
            );
          },
        ),
        Selector<DialogListItemViewModel, bool>(
          selector: (context, model) => model.dialogUserOnline,
          builder: (context, dialogUserOnline, child) {
            return Positioned(
              right: 0.0,
              bottom: 0.0,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                reverseDuration: Duration(milliseconds: 350),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                transitionBuilder: (child, animation) {
                  final scale =
                      Tween<double>(begin: 0.0, end: 1.0).animate(animation);
                  return ScaleTransition(
                    scale: scale,
                    child: child,
                  );
                },
                child: dialogUserOnline
                    ? Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: theme.data.backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: theme.data.accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
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
            Selector<DialogListItemViewModel, String>(
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
            Selector<DialogListItemViewModel, Message>(
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
    final theme = ThemeManager.of(context).currentTheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Selector<DialogListItemViewModel, Message>(
              selector: (context, model) => model.lastMessage,
              builder: (context, lastMessage, child) {
                return Expanded(
                  child: Text(
                    lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 130, 143, 152),
                    ),
                  ),
                );
              },
            ),
            Selector<DialogListItemViewModel, int>(
              selector: (context, model) => model.nonReadCounter,
              builder: (context, nonReadCounter, child) {
                if (nonReadCounter > 0) {
                  return Container(
                    width: 48.0,
                    margin: const EdgeInsets.only(left: 6.0),
                    child: UnconstrainedBox(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 24.0,
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        constraints: BoxConstraints(
                          minWidth: 24.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          color: theme.data.accentColor,
                        ),
                        child: Center(
                          child: Text(
                            '$nonReadCounter',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
