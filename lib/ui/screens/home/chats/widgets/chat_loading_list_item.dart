import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/constants/widgets.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';

class ChatLoadingListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _buildTitle(),
                      _buildSubtitle(),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeading() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.0,
          child: RoundedAvatar(
            backgroundColor: Color.fromARGB(255, 18, 28, 35),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 8.0,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 18, 28, 35),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              ),
            ),
            const Expanded(
              flex: 2,
              child: SizedBox.shrink(),
            ),
            Container(
              width: 40.0,
              margin: const EdgeInsets.only(left: 6.0),
              child: Container(
                height: 8.0,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 18, 28, 35),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: 8.0,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 18, 28, 35),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
