import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:telegram_clone_mobile/ui/icons/app_icons.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/rounded_avatar.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_provider.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_switcher.dart';

class NavDrawer extends StatefulWidget {
  @override
  NavDrawerState createState() => NavDrawerState();
}

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  ThemeSwitchState createState() => ThemeSwitchState();
}

class ThemeSwitchState extends State<ThemeSwitch> {
  Artboard? _riveArtboard;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/rive/theme_switcher.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        final brightness = ThemeManager.of(context).currentTheme.brightness;
        if (brightness == Brightness.dark)
          artboard.addController(SimpleAnimation('idle_sun'));
        else if (brightness == Brightness.light)
          artboard.addController(SimpleAnimation('idle_moon'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final brightness = ThemeManager.of(context).themeData.brightness;
    // if (brightness == Brightness.dark) {
    //   if (_show)
    //     return RenderObjectWrapper<String>(
    //       id: _id,
    //       manager: ThemeManager.of(context).renderManager,
    //       onUnmount: (_) {
    //         if (!_show) {
    //           ThemeManager.of(context).changeTheme(reverse: true);
    //         }
    //       },
    //       child: GestureDetector(
    //         onTap: () {
    //           ThemeManager.of(context).getSwitcherCoordinates(_id);
    //           ThemeManager.of(context)
    //               .setSwitcherKey(widget.key as GlobalKey<ThemeSwitchState>);
    //           show = false;
    //         },
    //         child: Icon(
    //           AppIcons.light_theme,
    //           color: Colors.white,
    //         ),
    //       ),
    //     );
    //   else
    //     return const SizedBox.shrink();
    // } else {
    //   if (_riveArtboard != null) {

    //     return GestureDetector(
    //       onTap: () {
    //         final brightness = ThemeManager.of(context).themeData.brightness;
    //
    //         if (brightness == Brightness.dark) {
    //           _riveArtboard!.addController(
    //               _riveController = SimpleAnimation('sun'));
    //           // setState(() => _riveController.isActive = true);
    //         } else if (brightness == Brightness.light) {
    //           _riveArtboard!.addController(
    //               _riveController = SimpleAnimation('moon'));
    //           // setState(() => _riveController.isActive = true);
    //         }
    //
    //         // ThemeManager.of(context).getSwitcherCoordinates(_id);
    //         ThemeManager.of(context)
    //             .setSwitcherKey(widget.key as GlobalKey<ThemeSwitchState>);
    //         ThemeManager.of(context).changeTheme();
    //       },
    //       child: _riveArtboard != null ? Rive(artboard: _riveArtboard!) : const SizedBox.shrink(),
    //     );

    // } else {
    //   return const SizedBox.shrink();
    // }
    // }
    // if (_show)
    //   return RenderObjectWrapper<String>(
    //     id: _id,
    //     manager: ThemeManager.of(context).renderManager,
    //     onUnmount: (_) {
    //       if (!_show) {
    //         ThemeManager.of(context).changeTheme(reverse: true);
    //       }
    //     },
    //     child: GestureDetector(
    //       onTap: () {
    //         ThemeManager.of(context).getSwitcherCoordinates(_id);
    //         ThemeManager.of(context).setSwitcherKey(widget.key as GlobalKey<ThemeSwitchState>);
    //         show = false;
    //       },
    //       child: Icon(
    //         AppIcons.light_theme,
    //         color: Colors.white,
    //       ),
    //     ),
    //   );
    // else
    //   return const SizedBox.shrink();
    return ThemeSwitcher(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            final brightness = ThemeManager.of(context).currentTheme.brightness;

            if (brightness == Brightness.dark) {
              _riveArtboard!.addController(SimpleAnimation('sun'));
              // ThemeSwitcher.of(context).changeTheme(data: Themes.lightTheme);
            } else if (brightness == Brightness.light) {
              _riveArtboard!.addController(SimpleAnimation('moon'));
              // ThemeSwitcher.of(context).changeTheme(data: Themes.darkTheme);
            }

            ThemeSwitcher.of(context).toggleBrightness();
          },
          child: _riveArtboard != null
              ? Rive(artboard: _riveArtboard!)
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class NavDrawerState extends State<NavDrawer> {
  final GlobalKey<ThemeSwitchState> _switcherKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.of(context).currentTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: theme.drawerHeaderBackground),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: RoundedAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    radius: 32,
                    text: 'Влад',
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2.0),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: ThemeSwitch(key: _switcherKey),
                  ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Влад',
                                style: TextStyle(
                                  color: theme.drawerHeaderTitleColor,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '+380 (95) 558 44 80',
                                style: TextStyle(
                                  color: theme.drawerHeaderSubtitleColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildNavItem(
            context: context,
            onTap: () {},
            icon: AppIcons.new_group,
            iconSize: 18,
            label: 'New Group',
          ),
          _buildNavItem(
            context: context,
            onTap: () {},
            icon: AppIcons.contacts,
            iconSize: 18,
            label: 'Contacts',
          ),
          _buildNavItem(
            context: context,
            onTap: () {},
            icon: AppIcons.saved_messages,
            iconSize: 20,
            label: 'Saved Messages',
          ),
          _buildNavItem(
            context: context,
            onTap: () {},
            icon: AppIcons.settings,
            iconSize: 22,
            label: 'Settings',
          ),
          _buildNavItem(
            context: context,
            onTap: () {},
            icon: Icons.logout,
            iconSize: 22,
            label: 'Sign out',
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required VoidCallback onTap,
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
}
