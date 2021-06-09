import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

import 'dialog_viewmodel.dart';

class DialogListItemViewModel extends BaseViewModel {
  late Message _lastMessage;

  Message get lastMessage => _lastMessage;

  update(DialogViewModel dialogViewModel) {
    _lastMessage = dialogViewModel.messages.first.data()!;
    notifyListeners();
  }
}
