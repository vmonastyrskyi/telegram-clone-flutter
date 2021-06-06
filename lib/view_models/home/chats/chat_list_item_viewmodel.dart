import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';
import 'package:telegram_clone_mobile/models/message.dart';

abstract class ChatListItemViewModel extends BaseViewModel {
  ChatListItemViewModel({
    required String id,
    required String title,
    required Message lastMessage,
  })   : _id = id,
        _title = title,
        _lastMessage = lastMessage;

  String _id;
  String _title;
  Message _lastMessage;

  String get id => _id;

  String get title => _title;

  set title(String title) {
    _title = title;
    notifyListeners();
  }

  Message get lastMessage => _lastMessage;

  set lastMessage(Message message) {
    _lastMessage = message;
    notifyListeners();
  }
}
