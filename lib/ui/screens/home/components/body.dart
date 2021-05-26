import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/screens/home/components/chat_list_item.dart';

class ChatData {
  String image;
  String title;
  String lastMessage;
  String lastMessageDate;
  int nonReadCounter;
  bool online;

  ChatData({
    required this.image,
    required this.title,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.nonReadCounter,
    required this.online,
  });
}

class Body extends StatelessWidget {
  final dialogs = <ChatData>[
    ChatData(
        image: 'assets/images/batman.png',
        title: 'Chat 1',
        lastMessage: 'Last message 1',
        lastMessageDate: 'Sun',
        nonReadCounter: 3,
        online: true),
    ChatData(
        image: 'assets/images/girl-kid.png',
        title: 'Chat 2',
        lastMessage: 'Last message 2 Last message 2 Last message 2',
        lastMessageDate: '13:49',
        nonReadCounter: 0,
        online: false),
    ChatData(
        image: 'assets/images/grandma.png',
        title: 'Chat 3',
        lastMessage: 'Last message 3 Last message 3',
        lastMessageDate: '20:18',
        nonReadCounter: 0,
        online: true),
    ChatData(
        image: 'assets/images/heisenberg.png',
        title: 'Chat 4',
        lastMessage: 'Last message 4',
        lastMessageDate: '23:00',
        nonReadCounter: 1238,
        online: false),
    ChatData(
        image: 'assets/images/spirit.png',
        title: 'Chat 5',
        lastMessage:
            'Last message 5 Last message 5 Last message 5 Last message 5',
        lastMessageDate: '7:50',
        nonReadCounter: 10,
        online: true),
    ChatData(
        image: 'assets/images/worker.png',
        title: 'Chat 6',
        lastMessage:
            'Last message 6 Last message 6 Last message 6 Last message 6',
        lastMessageDate: 'Mon',
        nonReadCounter: 567,
        online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: dialogs.map((dialog) => ChatListItem(data: dialog)).toList(),
    );
  }
}
