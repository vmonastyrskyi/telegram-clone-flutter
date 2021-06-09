import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/constants/widgets.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/util/sticky_sliver.dart';

class CountryGroupListItem extends StatelessWidget {
  const CountryGroupListItem({
    Key? key,
    required this.countryGroup,
  }) : super(key: key);

  final CountryGroup countryGroup;

  @override
  Widget build(BuildContext context) {
    return StickySliver(
      overlapsContent: true,
      leading: _buildLeading(context),
      content: _buildContent(context),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 6.0),
        width: WidgetsConstants.kCountryListItemHeight,
        height: WidgetsConstants.kCountryListItemHeight,
        child: Center(
          child: Text(
            countryGroup.group,
            style: TextStyle(
              color: Theme.of(context).textTheme.headline3!.color,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          for (final country in countryGroup.countries)
            Container(
              height: WidgetsConstants.kCountryListItemHeight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(country),
                child: Padding(
                  padding: const EdgeInsets.only(left: 72.0, right: 36.0),
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
            )
        ],
      ),
    );
  }
}
