import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone_mobile/constants/shared_preferences.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/models/user_details.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/services/firebase/auth_service.dart';
import 'package:telegram_clone_mobile/ui/icons/app_icons.dart';
import 'package:telegram_clone_mobile/ui/router.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_manager.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_switcher.dart';
import 'package:telegram_clone_mobile/util/phone_number_mask.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({
    Key? key,
    this.userDetails,
  }) : super(key: key);

  final UserDetails? userDetails;

  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer>
    with SingleTickerProviderStateMixin {
  static const int _kThemeSwitchingDuration = 700;

  final AuthService _authService = services.get<AuthService>();

  late final AnimationController _themeSwitcherController;

  String? _phoneNumberFormat;

  @override
  void initState() {
    super.initState();
    _themeSwitcherController = AnimationController(
      duration: Duration(milliseconds: _kThemeSwitchingDuration),
      vsync: this,
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadPhoneNumberFormat();
    });
  }

  void _loadPhoneNumberFormat() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCountryJson =
        prefs.getString(SharedPrefsConstants.kSelectedCountry);
    if (selectedCountryJson != null) {
      final selectedCountry = Country.fromJson(jsonDecode(selectedCountryJson));
      setState(() {
        _phoneNumberFormat = selectedCountry.format;
      });
    }
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
            iconSize: 18,
            label: 'New Group',
          ),
          _buildNavItem(
            icon: AppIcons.contacts,
            iconSize: 18,
            label: 'Contacts',
          ),
          _buildNavItem(
            icon: AppIcons.saved_messages,
            iconSize: 20,
            label: 'Saved Messages',
          ),
          _buildNavItem(
            icon: AppIcons.settings,
            iconSize: 22,
            label: 'Settings',
          ),
          _buildNavItem(
            onTap: () async {
              await _authService.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.Auth);
            },
            icon: Icons.logout,
            iconSize: 22,
            label: 'Log out',
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final theme = ThemeManager.of(context).currentTheme;

    return DrawerHeader(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 14.0, 10.0),
      decoration: BoxDecoration(color: theme.drawerHeaderBackground),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: widget.userDetails != null
                ? RoundedAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    radius: 32,
                    text: widget.userDetails!.firstName,
                  )
                : RoundedAvatar(
                    backgroundColor: Colors.blueGrey.withOpacity(0.5),
                    radius: 32,
                  ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _buildThemeSwitcher(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (widget.userDetails != null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.userDetails!.firstName} ${widget.userDetails!.lastName}',
                                style: TextStyle(
                                  color: theme.drawerHeaderTitleColor,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _phoneNumberFormat != null
                                    ? PhoneNumberMask.format(
                                        text: widget.userDetails!.phoneNumber,
                                        mask: _phoneNumberFormat!)
                                    : widget.userDetails!.phoneNumber,
                                style: TextStyle(
                                  color: theme.drawerHeaderSubtitleColor,
                                  fontSize: 13,
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
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
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
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
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
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: Theme.of(context).textTheme.headline2!.color,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color:
                        color ?? Theme.of(context).textTheme.headline1!.color,
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
