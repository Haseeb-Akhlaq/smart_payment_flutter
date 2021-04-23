import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartpayment_flutter/models/companies_model.dart';
import 'package:smartpayment_flutter/models/recent_companies_model.dart';
import 'package:smartpayment_flutter/screens/BottomNavBar/payBillScreen.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppUser appUser;
  bool isLoading = false;

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    final userId = FirebaseAuth.instance.currentUser.uid;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    appUser = AppUser.fromMap(userData.data());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Wallet'),
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                })
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appUser.userName,
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Remaing Balance:   £${appUser.walletBalance}',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('All Recent Companies'),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        child: RecentCompanies(),
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class RecentCompanies extends StatefulWidget {
  @override
  _RecentCompaniesState createState() => _RecentCompaniesState();
}

class _RecentCompaniesState extends State<RecentCompanies> {
  final userId = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('savedCompanies')
          .doc(userId)
          .collection('companies')
          .get(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List firebaseData = futureSnapshot.data.docs;

        final List<RecentCompanyModel> allRecentCompanies = firebaseData
            .map((e) => RecentCompanyModel.fromMap(e.data()))
            .toList();

        return GridView.builder(
          itemCount: allRecentCompanies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PayBillScreen(
                        company: LocalCompanyModel(
                            id: allRecentCompanies[index].id,
                            name: allRecentCompanies[index].name,
                            pic: allRecentCompanies[index].pic,
                            tags: []),
                        isedit: true,
                        recentCompanyModel: allRecentCompanies[index],
                      ),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 150,
                      child: Image.network(allRecentCompanies[index].pic),
                    ),
                    Text(allRecentCompanies[index].name),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      timeago.format(allRecentCompanies[index].time),
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.65,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
        );
      },
    );
  }
}
