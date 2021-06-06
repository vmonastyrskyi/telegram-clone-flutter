import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/chat_list_item_viewmodel.dart';

class SavedMessagesListItemViewModel extends ChatListItemViewModel {
  SavedMessagesListItemViewModel({
    required String id,
    required String title,
    required Message lastMessage,
  }) : super(
          id: id,
          title: title,
          lastMessage: lastMessage,
        );
}
