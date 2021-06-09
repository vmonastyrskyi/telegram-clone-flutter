import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/chat.dart';
import 'package:telegram_clone_mobile/models/message.dart';
import 'package:telegram_clone_mobile/services/auth_service.dart';
import 'package:telegram_clone_mobile/services/chat_service.dart';
import 'package:telegram_clone_mobile/services/user_service.dart';

import 'chat_viewmodel.dart';

class DialogViewModel extends ChatViewModel {
  DialogViewModel({
    required DocumentSnapshot<Chat> snapshot,
  }) : super(snapshot: snapshot) {
    _scrollController.addListener(_onScroll);
    _loadedMessages = List.generate(100, (index) => 'Item ${index + 1}');
  }

  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  late String _title;
  late String _dialogUserId;
  late String _dialogUserOnlineStatus;
  late bool _dialogUserOnline;
  late int _unreadMessageCounter;
  late List<DocumentSnapshot<Message>> _messages;

  // late List<MessageViewModel> _loadedMessages;
  late List<String> _loadedMessages;
  final ScrollController _scrollController = ScrollController();
  bool _messageLoading = false;

  String get title => _title;

  String get dialogUserId => _dialogUserId;

  bool get dialogUserOnline => _dialogUserOnline;

  int get unreadMessageCounter => _unreadMessageCounter;

  String get dialogUserOnlineStatus => _dialogUserOnlineStatus;

  List<DocumentSnapshot<Message>> get messages => _messages;

  List<String> get loadedMessages => _loadedMessages;

  // List<MessageViewModel> get loadedMessages => _loadedMessages;

  ScrollController get scrollController => _scrollController;

  Future<void> initialize() async {
    final chat = snapshot.data()!;
    final dialogUserId = chat.users
        .firstWhere((userRef) => userRef.id != _authService.currentUser!.uid)
        .id;
    final dialogUserSnapshot = await _userService.getUserById(id: dialogUserId);
    final dialogUser = dialogUserSnapshot.data()!;

    _title = '${dialogUser.firstName} ${dialogUser.lastName}'.trim();
    _messages = await _getMessages();
    _dialogUserId = dialogUserId;
    _changeOnlineStatus(dialogUser.online);
    _unreadMessageCounter = await _getUnreadMessageCounter();

    listenUserChanges();
    listenChatChanges();
  }

  Future<List<DocumentSnapshot<Message>>> _getMessages() async {
    return (await _chatService.getMessages(id: snapshot.id)).docs;
  }

  Future<int> _getUnreadMessageCounter() async {
    final unreadMessageSnapshots =
        (await _chatService.getUnreadMessages(id: snapshot.id)).docs;
    return unreadMessageSnapshots
        .where((snapshot) => snapshot.data().owner.id == _dialogUserId)
        .length;
  }

  void _changeOnlineStatus(bool online) {
    if (_dialogUserOnline = online) {
      _dialogUserOnlineStatus = 'online';
    } else {
      _dialogUserOnlineStatus = 'last seen recently';
    }
  }

  void listenUserChanges() {
    _userService.onUserChanged(id: dialogUserId).listen((userSnapshot) {
      if (userSnapshot.exists && userSnapshot.data() != null) {
        final dialogUser = userSnapshot.data()!;
        _title = '${dialogUser.firstName.trim()} ${dialogUser.lastName.trim()}';
        _changeOnlineStatus(dialogUser.online);
        notifyListeners();
      }
    });
  }

  void listenChatChanges() {
    _chatService
        .onChatMessagesChanged(id: snapshot.id)
        .listen((messageSnapshots) {
      if (messageSnapshots.size > 0) {
        _messages = messageSnapshots.docs;
        final messages = messageSnapshots.docs
            .map((messageSnapshot) => messageSnapshot.data())
            .toList();
        _unreadMessageCounter = messages
            .where(
                (message) => !message.read && message.owner.id == _dialogUserId)
            .length;
        notifyListeners();
      }
    });
  }

  void _onScroll() {
    if (!_messageLoading &&
        _scrollController.offset >
            _scrollController.position.maxScrollExtent * 0.75) {
      _messageLoading = true;
      _loadedMessages.addAll(List.generate(
          100, (index) => "Item ${_loadedMessages.length + index + 1}"));
      _messageLoading = false;
      print(_loadedMessages.length);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
