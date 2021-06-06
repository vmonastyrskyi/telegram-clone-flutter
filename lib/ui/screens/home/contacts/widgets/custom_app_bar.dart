import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/appbar_icon_button.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: buildTitle(context),
      ),
      leading: AppBarIconButton(
        icon: Icons.arrow_back,
        onTap: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        AppBarIconButton(
          onTap: () {},
          icon: Icons.search,
          iconSize: 24,
          iconColor: Theme.of(context).textTheme.headline1!.color!,
        ),
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('Contacts'),
      ],
    );
  }
}
