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
        name: 'Hastings Insurance',
        pic:
            'https://upload.wikimedia.org/wikipedia/en/thumb/1/1c/Hastings_Insurance_logo.svg/1200px-Hastings_Insurance_logo.svg.png',
        tags: [
          'Insurance',
          'insurance.',
          'h',
          'Hasting',
        ]),
    LocalCompanyModel(
        id: '2',
        name: 'Directline Insurance',
        pic: 'https://www.directline.com/assets/images/logo.webp',
        tags: [
          'Insurance',
          'insurance.',
          'd',
          'Directline',
        ]),
    LocalCompanyModel(
        id: '3',
        name: 'EE Limited',
        pic:
            'https://cached.imagescaler.hbpl.co.uk/resize/scaleWidth/743/cached.offlinehbpl.hbpl.co.uk/news/OMC/265100C4-9201-D612-15772E6064E9338B.jpg',
        tags: [
          'ee',
          'e',
          'EE Limited',
          'e',
        ]),
    LocalCompanyModel(
        id: '4',
        name: 'Vodafone',
        pic:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz6sqNrkAhk325cZ63whBYsZ_KvUt5NEJBxg&usqp=CAU',
        tags: [
          'mobile',
          'ph',
          'phone',
          'Vodafone',
          'vodafone'
              'v',
        ]),
    LocalCompanyModel(
        id: '5',
        name: 'SES Water',
        pic:
            'https://upload.wikimedia.org/wikipedia/en/c/cd/SES_Water_Logo.png',
        tags: [
          'SES Water',
          'ses',
          's',
        ]),
    LocalCompanyModel(
        id: '6',
        name: 'British Gas',
        pic:
            'https://upload.wikimedia.org/wikipedia/en/thumb/1/11/British_Gas_logo.svg/1200px-British_Gas_logo.svg.png',
        tags: ['British Gas', 'british', 'gas', 'b']),
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
        query.isEmpty ? companies : searchResults(query);

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
                      isedit: false,
                      recentCompanyModel: null,
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
