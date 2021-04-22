import 'package:flutter/material.dart';

import '../../models/companies_model.dart';
import 'payBillScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Companies'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CompaniesSearch(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CompaniesSearch extends SearchDelegate<String> {
  searchResults(String query) {
    final tagsResults =
        companies.where((element) => element.tags.contains(query)).toList();
    final nameResults =
        companies.where((element) => element.name.startsWith(query)).toList();
    return [...tagsResults, ...nameResults];
  }

  List<LocalCompanyModel> companies = [
    LocalCompanyModel(
        id: '1',
        name: 'Pacific Gas & Electric',
        pic:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Pacific_Gas_and_Electric_Company_%28logo%29.svg/160px-Pacific_Gas_and_Electric_Company_%28logo%29.svg.png',
        tags: [
          'electric',
          'Pacific Gas & Electric',
          'electricity',
          'pacific',
          'gas',
          'p',
        ]),
    LocalCompanyModel(
        id: '2',
        name: 'Georgia Power',
        pic:
            'https://upload.wikimedia.org/wikipedia/en/thumb/5/56/Georgia_Power_logo.svg/156px-Georgia_Power_logo.svg.png',
        tags: [
          'electric',
          'Georgia Power',
          'electricity',
          'pacific',
          'gas',
          'g',
        ]),
    LocalCompanyModel(
        id: '3',
        name: 'DTE Energy',
        pic:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/DTE_Logo_Blue.svg/220px-DTE_Logo_Blue.svg.png',
        tags: [
          'ele'
              'electric',
          'DTE Energy',
          'electricity',
          'pacific',
          'gas',
          'd',
        ]),
    LocalCompanyModel(
        id: '4',
        name: 'Mint Mobile',
        pic:
            'https://cdn.mos.cms.futurecdn.net/VtBoNedemNoaRqp6tW9tEb-970-80.jpg.webp',
        tags: [
          'mobile',
          'ph',
          'phone',
          'm',
          'mint',
        ]),
  ];

  List<LocalCompanyModel> recentList = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    List<LocalCompanyModel> suggestionList =
        query.isEmpty ? recentList : searchResults(query);

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PayBillScreen(
                      company: suggestionList[index],
                    ),
                  ));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(suggestionList[index].pic),
                    radius: 20,
                  ),
                  title: Text(suggestionList[index].name),
                ),
              ),
            ),
          );
        });
  }
}
