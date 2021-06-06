import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/util/multi_sliver.dart';
import 'package:telegram_clone_mobile/view_models/auth/select_country/custom_app_bar_view_model.dart';
import 'package:telegram_clone_mobile/view_models/auth/select_country/select_country_viewmodel.dart';

import 'strings.dart';
import 'widgets/country_group_list_item.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/searched_country_list_item.dart';

class SelectCountryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ChangeNotifierProvider(
          create: (_) => CustomAppBarViewModel(),
          child: CustomAppBar(),
        ),
      ),
      body: Consumer<SelectCountryViewModel>(
        builder: (_, model, __) {
          final countriesGroups = model.countriesGroups;
          final searchedCountries = model.searchedCountries;
          final enableCountrySearch = model.enableCountrySearch;

          if (enableCountrySearch)
            return CustomScrollView(
              slivers: <Widget>[
                if (searchedCountries.isNotEmpty)
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
                        SelectCountryStrings.kNoResultsText,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline2!.color,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          else
            return CustomScrollView(
              slivers: <Widget>[
                for (int i = 0; i < countriesGroups.length; i++)
                  MultiSliver(
                    children: <Widget>[
                      CountryGroupListItem(
                        countryGroup: countriesGroups[i],
                      ),
                      if (i != countriesGroups.length - 1)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(72.0, 8.0, 24.0, 8.0),
                            child: Divider(height: 0.5),
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
