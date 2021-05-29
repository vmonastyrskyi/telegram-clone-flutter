import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/provider/select_country_provider.dart';

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
          height: 50,
          child: InkWell(
            onTap: () {
              context.read<SelectCountryProvider>().selectCountry(country);
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 18),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      country.name,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    '+${country.code}',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 17,
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
            left: 20,
            right: 0,
            bottom: 0,
            child: Divider(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          )
      ],
    );
  }
}