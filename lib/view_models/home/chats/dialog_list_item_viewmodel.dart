import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/services/chat_service.dart';
import 'package:telegram_clone_mobile/services/user_service.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/chat_list_item_viewmodel.dart';

class DialogListItemViewModel extends ChatListItemViewModel {
  DialogListItemViewModel({
    required String id,
    required String title,
    required Message lastMessage,
    required String dialogUserId,
    required int nonReadCounter,
  })   : _dialogUserId = dialogUserId,
        _nonReadCounter = nonReadCounter,
        super(
          id: id,
          title: title,
          lastMessage: lastMessage,
        );

  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  String _dialogUserId;
  int _nonReadCounter;
  bool _dialogUserOnline = false;

  String get dialogUserId => _dialogUserId;

  int get nonReadCounter => _nonReadCounter;

  set nonReadCounter(int value) {
    _nonReadCounter = value;
    notifyListeners();
  }

  bool get dialogUserOnline => _dialogUserOnline;

  set dialogUserOnline(bool online) {
    _dialogUserOnline = online;
    notifyListeners();
  }

  void listenOnUserChanged() {
    _userService.onUserChanged(userId: dialogUserId).listen((userDetailsSnap) {
      if (userDetailsSnap.exists && userDetailsSnap.data() != null) {
        final userDetails = userDetailsSnap.data()!;
        title = '${userDetails.firstName} ${userDetails.lastName}'.trim();
        dialogUserOnline = userDetails.online;
      }
    });
  }

  void listenOnChatChanged() {
    _chatService.onChatMessagesChanged(chatId: id).listen((messagesSnaps) {
      if (messagesSnaps.size > 0) {
        final messages = messagesSnaps.docs
            .map((messageSnap) => messageSnap.data())
            .toList();
        nonReadCounter = messages
            .where(
                (message) => !message.read && message.owner.id == dialogUserId)
            .length;
      }
    });
  }
}
