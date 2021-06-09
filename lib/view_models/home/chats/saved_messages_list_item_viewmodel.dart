import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

import 'saved_messages_viewmodel.dart';

class SavedMessagesListItemViewModel extends BaseViewModel {
  late Message _lastMessage;

  Message get lastMessage => _lastMessage;

  update(SavedMessagesViewModel dialogViewModel) {
    _lastMessage = dialogViewModel.messages.first.data()!;
    notifyListeners();
  }
}
