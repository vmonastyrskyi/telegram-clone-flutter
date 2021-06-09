import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/constants/widgets.dart';
import 'package:telegram_clone_mobile/models/country.dart';

class SearchedCountryListItem extends StatelessWidget {
  const SearchedCountryListItem({
    Key? key,
    required this.country,
    this.showDivider = true,
  }) : super(key: key);

  final Country country;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: WidgetsConstants.kCountryListItemHeight,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(country),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 18.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      country.name,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    '+${country.code}',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Positioned(
            left: 20.0,
            right: 0.0,
            bottom: 0.0,
            child: Divider(height: 0.5),
          )
      ],
    );
  }
}
