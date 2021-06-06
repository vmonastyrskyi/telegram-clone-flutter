import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/appbar_icon_button.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/clear_button.dart';
import 'package:telegram_clone_mobile/view_models/auth/select_country/custom_app_bar_view_model.dart';
import 'package:telegram_clone_mobile/view_models/auth/select_country/select_country_viewmodel.dart';

import '../strings.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  final UniqueKey _titleKey = UniqueKey();
  final UniqueKey _countrySearchKey = UniqueKey();

  late final AnimationController _clearButtonAnimationController;

  @override
  void initState() {
    super.initState();
    _clearButtonAnimationController = AnimationController(
      duration: Duration(milliseconds: 175),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _clearButtonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enableCountrySearch = context.select<SelectCountryViewModel, bool>(
        (model) => model.enableCountrySearch);

    return Consumer<CustomAppBarViewModel>(
      builder: (_, model, __) {
        return AppBar(
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
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
              child: enableCountrySearch ? _buildCountrySearch() : _buildTitle(),
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
                iconSize: 24.0,
                iconColor: Theme.of(context).textTheme.headline1!.color!,
              ),
            if (model.showClearButton)
              ClearButton(
                controller: _clearButtonAnimationController,
                onTap: () async {
                  model.clearCountrySearchInput();
                  context
                      .read<SelectCountryViewModel>()
                      .clearSearchedCountries();

                  await _clearButtonAnimationController.reverse();
                  model.showClearButton = false;
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildTitle() {
    return Row(
      key: _titleKey,
      children: <Widget>[
        Text(SelectCountryStrings.kTitle),
      ],
    );
  }

  Widget _buildCountrySearch() {
    final countrySearchController =
        context.read<CustomAppBarViewModel>().countrySearchController;

    return Row(
      key: _countrySearchKey,
      children: <Widget>[
        Consumer<CustomAppBarViewModel>(
          builder: (_, model, __) {
            return Expanded(
              child: TextField(
                onChanged: (text) async {
                  if (text.isNotEmpty) {
                    if (!model.showClearButton) {
                      model.showClearButton = true;
                    }
                    _clearButtonAnimationController.forward();
                  } else {
                    if (model.showClearButton) {
                      await _clearButtonAnimationController.reverse();
                      model.showClearButton = false;
                    } else {
                      _clearButtonAnimationController.forward();
                    }
                  }
                  context
                      .read<SelectCountryViewModel>()
                      .findCountryByName(text);
                },
                autofocus: true,
                autocorrect: true,
                controller: countrySearchController,
                cursorColor: Theme.of(context).textTheme.headline1!.color,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: SelectCountryStrings.kCountrySearchHintText,
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.headline2!.color,
                    fontSize: 18.0,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _toggleCountrySearch(bool enableSearch) {
    final selectCountryModel = context.read<SelectCountryViewModel>();
    final customAppBarModel = context.read<CustomAppBarViewModel>();

    selectCountryModel.enableCountrySearch = enableSearch;
    customAppBarModel.showClearButton = false;
    customAppBarModel.clearCountrySearchInput();
  }
}
