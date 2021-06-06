import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/chat.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/services/auth_service.dart';
import 'package:telegram_clone_mobile/services/chat_service.dart';
import 'package:telegram_clone_mobile/services/user_service.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

import 'chat_list_item_viewmodel.dart';
import 'dialog_list_item_viewmodel.dart';
import 'saved_messages_list_item_viewmodel.dart';

class ChatsViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  List<ChatListItemViewModel> _chats = [];
  bool _chatsLoaded = false;

  List<ChatListItemViewModel> get chats => _chats;

  bool get chatsLoaded => _chatsLoaded;

  set chatsLoaded(bool loaded) {
    _chatsLoaded = loaded;
    notifyListeners();
  }

  void loadChats() async {
    final chatRefs = await _userService.getChats();

    await Future.forEach<DocumentReference>(chatRefs, (chatRef) async {
      final chatSnap = await _chatService.getChatById(chatId: chatRef.id);
      if (chatSnap.exists && chatSnap.data() != null) {
        final chat = chatSnap.data()!;

        if (chat.messageCounter > 0) {
          switch (chat.type) {
            case ChatType.SavedMessages:
              final lastMessage = await _getLastMessage(chatSnap);

              _chats.add(
                SavedMessagesListItemViewModel(
                  id: chatSnap.id,
                  title: 'Saved Messages',
                  lastMessage: lastMessage,
                ),
              );
              break;
            case ChatType.Dialog:
              final lastMessage = await _getLastMessage(chatSnap);

              final dialogUserDetailsSnap = await _userService.getUserById(
                userId: chat.users
                    .where((userRef) =>
                        userRef.id != _authService.currentUser!.uid)
                    .first
                    .id,
              );
              if (!dialogUserDetailsSnap.exists) {
                return;
              }

              final dialogUserDetails = dialogUserDetailsSnap.data()!;
              final chatTitle =
                  '${dialogUserDetails.firstName} ${dialogUserDetails.lastName}'
                      .trim();
              final dialogUserId = dialogUserDetailsSnap.id;

              int nonReadCounter = 0;
              final nonReadMessageSnaps = (await chatSnap.reference
                      .collection(ChatFields.Messages)
                      .where(MessageFields.Read, isEqualTo: false)
                      .where(MessageFields.Owner, isEqualTo: dialogUserId)
                      .get())
                  .docs;
              if (nonReadMessageSnaps.isNotEmpty) {
                nonReadCounter = nonReadMessageSnaps.length;
              }

              _chats.add(
                DialogListItemViewModel(
                  id: chatSnap.id,
                  title: chatTitle,
                  lastMessage: lastMessage,
                  dialogUserId: dialogUserId,
                  nonReadCounter: nonReadCounter,
                ),
              );
              break;
          }
        }
      }
    });

    listenChatsChanges();

    chatsLoaded = true;
  }

  Future<Message> _getLastMessage(DocumentSnapshot<Chat> snapshot) async {
    final lastMessageSnap = (await snapshot.reference
            .collection(ChatFields.Messages)
            .orderBy(MessageFields.CreatedAt, descending: true)
            .limit(1)
            .get())
        .docs;
    return Message.fromJson(lastMessageSnap.first.data());
  }

  void listenChatsChanges() {
    _chats.forEach((chat) {
      _chatService.onChatMessagesChanged(chatId: chat.id).listen((messagesSnaps) {
        if (messagesSnaps.size > 0) {
          final messages = messagesSnaps.docs
              .map((messageSnap) => messageSnap.data())
              .toList();
          messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          chat.lastMessage = messages.first;
          _sortChatsByLastMessageDate();
        }
      });
    });
  }

  void _sortChatsByLastMessageDate() {
    _chats.sort(
        (a, b) => b.lastMessage.createdAt.compareTo(a.lastMessage.createdAt));
    notifyListeners();
  }
}
