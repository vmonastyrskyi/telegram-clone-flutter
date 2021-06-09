import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/chat.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/services/chat_service.dart';
import 'package:telegram_clone_mobile/services/user_service.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/saved_messages_viewmodel.dart';

import 'chat_viewmodel.dart';
import 'dialog_viewmodel.dart';

class ChatsViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  List<ChatViewModel> _chats = [];
  bool _chatsLoaded = false;

  List<ChatViewModel> get chats => _chats;

  bool get chatsLoaded => _chatsLoaded;

  set chatsLoaded(bool loaded) {
    _chatsLoaded = loaded;
    notifyListeners();
  }

  void loadChats() async {
    final chatRefs = await _userService.getChats();

    await Future.forEach<DocumentReference>(chatRefs, (chatRef) async {
      final chatSnapshot = await _chatService.getChatById(id: chatRef.id);

      if (chatSnapshot.exists && chatSnapshot.data() != null) {
        final chatData = chatSnapshot.data()!;

        switch (chatData.type) {
          case ChatType.SavedMessages:
            final model = SavedMessagesViewModel(snapshot: chatSnapshot);
            await model.initialize();
            _chats.add(model);
            break;
          case ChatType.Dialog:
            final model = DialogViewModel(snapshot: chatSnapshot);
            await model.initialize();
            _chats.add(model);
            break;
          case ChatType.Group:
            break;
        }
      }
    });

    listenChatsChanges();

    chatsLoaded = true;
  }

  void listenChatsChanges() {
    _chats.forEach((chat) {
      _chatService.onChatMessagesChanged(id: chat.snapshot.id).listen((_) {
        _sortChatsByLastMessageDate();
      });
    });
  }

  void _sortChatsByLastMessageDate() {
    _chats.sort((a, b) {
      final lastMessageA = _getLastMessage(a);
      final lastMessageB = _getLastMessage(b);
      if (lastMessageA != null && lastMessageB != null) {
        return lastMessageB.createdAt.compareTo(lastMessageA.createdAt);
      } else {
        return 0;
      }
    });
    notifyListeners();
  }

  Message? _getLastMessage(ChatViewModel chatViewModel) {
    if (chatViewModel is SavedMessagesViewModel) {
      return chatViewModel.messages.first.data();
    } else if (chatViewModel is DialogViewModel) {
      return chatViewModel.messages.first.data();
    }
  }
}
