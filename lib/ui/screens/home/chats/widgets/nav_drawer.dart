import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/ui/icons/app_icons.dart';
import 'package:telegram_clone_mobile/ui/router.dart';
import 'package:telegram_clone_mobile/ui/screens/home/router.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';
import 'package:telegram_clone_mobile/ui/theming/theme_manager.dart';
import 'package:telegram_clone_mobile/ui/theming/theme_switcher.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/nav_drawer_viewmodel.dart';
import 'package:telegram_clone_mobile/view_models/home/home_viewmodel.dart';

import '../strings.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key? key}) : super(key: key);

  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer>
    with SingleTickerProviderStateMixin {
  static const int _kThemeSwitchingDuration = 700;

  late final AnimationController _themeSwitcherController;

  @override
  void initState() {
    super.initState();
    _themeSwitcherController = AnimationController(
      duration: Duration(milliseconds: _kThemeSwitchingDuration),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _themeSwitcherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          _buildNavItem(
            icon: AppIcons.new_group,
            iconSize: 18.0,
            label: ChatsStrings.kNavItemNewGroupLabel,
          ),
          _buildNavItem(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(HomeRoutes.Contacts);
            },
            icon: AppIcons.contacts,
            iconSize: 18.0,
            label: ChatsStrings.kNavItemContactsLabel,
          ),
          _buildNavItem(
            icon: AppIcons.saved_messages,
            iconSize: 20.0,
            label: ChatsStrings.kNavItemSavedMessagesLabel,
          ),
          _buildNavItem(
            icon: AppIcons.settings,
            iconSize: 22.0,
            label: ChatsStrings.kNavItemSettingsLabel,
          ),
          Divider(height: 0.5),
          _buildNavItem(
            onTap: () async {
              await context.read<NavDrawerViewModel>().logout();
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(AppRoutes.Auth);
            },
            icon: Icons.logout,
            iconSize: 22.0,
            label: ChatsStrings.kNavItemLogoutLabel,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final theme = ThemeManager.of(context).currentTheme;
    final userDetails = context.read<HomeViewModel>().userDetails;
    final formattedPhoneNumber =
        context.read<HomeViewModel>().formattedPhoneNumber;

    return DrawerHeader(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 14.0, 10.0),
      decoration: BoxDecoration(color: theme.drawerHeaderBackground),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: userDetails != null
                ? RoundedAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    radius: 32.0,
                    text: userDetails.firstName,
                  )
                : RoundedAvatar(
                    backgroundColor: Colors.blueGrey.withOpacity(0.5),
                    radius: 32.0,
                  ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _buildThemeSwitcher(),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 40.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (userDetails != null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${userDetails.firstName} ${userDetails.lastName}'
                                    .trim(),
                                style: TextStyle(
                                  color: theme.drawerHeaderTitleColor,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                formattedPhoneNumber ?? userDetails.phoneNumber,
                                style: TextStyle(
                                  color: theme.drawerHeaderSubtitleColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    VoidCallback? onTap,
    required IconData icon,
    required double iconSize,
    required String label,
    Color? color,
  }) {
    final theme = ThemeManager.of(context).currentTheme;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 48.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: theme.data.textTheme.headline2!.color,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: color ?? theme.data.textTheme.headline1!.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(2.0),
      width: 34.0,
      height: 34.0,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: ThemeSwitcher(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              final brightness =
                  ThemeManager.of(context).currentTheme.brightness;

              if (brightness == Brightness.dark)
                _themeSwitcherController.forward(from: 0.0);
              else if (brightness == Brightness.light)
                _themeSwitcherController.reverse(from: 1.0);

              ThemeSwitcher.of(context).toggleBrightness();
            },
            child: Lottie.asset(
              'assets/lottie/theme_switcher.json',
              controller: CurvedAnimation(
                parent: _themeSwitcherController,
                curve: Curves.easeInOutCubic,
              ),
              frameRate: FrameRate.max,
              onLoaded: (composition) {
                final brightness =
                    ThemeManager.of(context).currentTheme.brightness;
                if (brightness == Brightness.dark)
                  _themeSwitcherController.value = 0.0;
                else if (brightness == Brightness.light)
                  _themeSwitcherController.value = 1.0;
              },
            ),
          );
        },
      ),
    );
  }
}
