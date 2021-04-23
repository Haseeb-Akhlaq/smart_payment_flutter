import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transcation History'),
        centerTitle: true,
      ),
      body: TranscationHistory(),
    );
  }
}

class TranscationHistory extends StatefulWidget {
  @override
  _TranscationHistoryState createState() => _TranscationHistoryState();
}

class _TranscationHistoryState extends State<TranscationHistory> {
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

        // final List<RecentCompanyModel> allRecentCompanies = firebaseData
        //     .map((e) => RecentCompanyModel.fromMap(e.data()))
        //     .toList();

        return ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 2,
            );
          },
          itemCount: firebaseData.length,
          itemBuilder: (context, index) {
            var date = Timestamp.fromMillisecondsSinceEpoch(
                    firebaseData[index].data()['time'].millisecondsSinceEpoch)
                .toDate();
            return ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: Image.network(firebaseData[index].data()['companyPic']),
              ),
              title: Text(firebaseData[index].data()['companyName']),
              subtitle: Text(
                ' "${DateFormat.yMd().add_jms().format(date)}"',
                style: TextStyle(fontSize: 12),
              ),
              trailing: Text(
                '£${firebaseData[index].data()['amountPaid']}',
                style: TextStyle(fontSize: 18),
              ),
            );
          },
        );
      },
    );
  }
}
