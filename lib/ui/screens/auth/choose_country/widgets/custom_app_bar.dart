import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/business_logic/view_models/choose_country.dart';
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
  final _titleKey = UniqueKey();
  final _countrySearchKey = UniqueKey();
  final _countrySearchController = TextEditingController();

  late final AnimationController _clearButtonController;

  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _clearButtonController = AnimationController(
      duration: Duration(milliseconds: 175),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _countrySearchController.dispose();
    _clearButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enableCountrySearch = context.select(
        (ChooseCountryProvider chooseCountry) =>
            chooseCountry.enableCountrySearch);

    return AppBar(
      elevation: 1.5,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 175),
          reverseDuration: Duration(milliseconds: 175),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (child, animation) {
            final scale =
                Tween<double>(begin: 0.985, end: 1.0).animate(animation);
            final opacity =
                Tween<double>(begin: 0.0, end: 1.0).animate(animation);
            return ScaleTransition(
              alignment: Alignment.centerLeft,
              scale: scale,
              child: FadeTransition(
                opacity: opacity,
                child: child,
              ),
            );
          },
          child: enableCountrySearch
              ? _buildCountrySearch(context)
              : _buildTitle(context),
        ),
      ),
      leading: AppBarIconButton(
        icon: Icons.arrow_back,
        onTap: () {
          enableCountrySearch
              ? _toggleCountrySearch(false)
              : Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[
        if (!enableCountrySearch)
          AppBarIconButton(
            onTap: () => _toggleCountrySearch(true),
            icon: Icons.search,
            iconSize: 24,
            iconColor: Theme.of(context).textTheme.headline1!.color!,
          ),
        if (_showClearButton)
          _ClearButton(
              controller: _clearButtonController,
              onPressed: () {
                _countrySearchController.clear();
                _clearButtonController.reverse().whenComplete(() {
                  setState(() => _showClearButton = false);
                });
                context.read<ChooseCountryProvider>().clearSearchedCountries();
              }),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      key: _titleKey,
      children: <Widget>[
        Text('Choose a country'),
      ],
    );
  }

  Widget _buildCountrySearch(BuildContext context) {
    return Row(
      key: _countrySearchKey,
      children: <Widget>[
        Expanded(
          child: TextField(
            onChanged: (String value) {
              if (value.length > 0) {
                if (!_showClearButton) setState(() => _showClearButton = true);
                _clearButtonController.forward();
              } else {
                if (_showClearButton)
                  _clearButtonController.reverse().whenComplete(() {
                    setState(() => _showClearButton = false);
                  });
                else
                  _clearButtonController.forward();
              }
              context
                  .read<ChooseCountryProvider>()
                  .findCountryByName(value.trim());
            },
            autofocus: true,
            autocorrect: true,
            controller: _countrySearchController,
            cursorColor: Theme.of(context).textTheme.headline1!.color,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1!.color,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Theme.of(context).textTheme.headline2!.color,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleCountrySearch(bool value) {
    setState(() => _showClearButton = false);
    context.read<ChooseCountryProvider>().enableCountrySearch = value;
    _countrySearchController.clear();
  }
}

class _ClearButton extends AnimatedWidget {
  _ClearButton({
    Key? key,
    required this.controller,
    required this.onPressed,
  })   : _scale = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutSine,
          ),
        ),
        _rotation = Tween<double>(
          begin: 0.125,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutSine,
          ),
        ),
        super(key: key, listenable: controller);

  final AnimationController controller;
  final VoidCallback onPressed;

  final Animation<double> _scale;
  final Animation<double> _rotation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ScaleTransition(
          scale: _scale,
          child: RotationTransition(
            turns: _rotation,
            child: buildClearButton(context),
          ),
        ),
      ],
    );
  }

  Widget buildClearButton(BuildContext context) {

    return AppBarIconButton(
      onTap: onPressed,
      icon: Icons.close,
      iconSize: 24,
      iconColor: Theme.of(context).textTheme.headline1!.color!,
      splash: false,
    );
  }
}
