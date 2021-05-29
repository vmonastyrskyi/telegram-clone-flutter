import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/provider/select_country_provider.dart';
import 'package:telegram_clone_mobile/util/multi_sliver.dart';

import 'widgets/country_group_list_item.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/searched_country_list_item.dart';

class SelectCountryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<SelectCountryProvider>(
        builder: (_, chooseCountry, __) {
          final countriesGroups = chooseCountry.countriesGroups;
          final searchedCountries = chooseCountry.searchedCountries;
          final enableCountrySearch = chooseCountry.enableCountrySearch;

          if (enableCountrySearch)
            return CustomScrollView(
              slivers: <Widget>[
                if (searchedCountries.length > 0)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return SearchedCountryListItem(
                          country: searchedCountries[index],
                          showDivider: index < searchedCountries.length - 1,
                        );
                      },
                      childCount: searchedCountries.length,
                    ),
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No results',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline2!.color,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          else
            return CustomScrollView(
              slivers: <Widget>[
                for (var i = 0; i < countriesGroups.length; i++)
                  MultiSliver(
                    children: <Widget>[
                      CountryGroupListItem(
                        countryGroup: countriesGroups[i],
                      ),
                      if (i != countriesGroups.length - 1)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(72, 8, 24, 8),
                            child: Divider(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                    ],
                  )
              ],
            );
        },
      ),
    );
  }
}
