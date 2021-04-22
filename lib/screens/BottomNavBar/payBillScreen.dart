import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/companies_model.dart';

class PayBillScreen extends StatefulWidget {
  final LocalCompanyModel company;

  const PayBillScreen({this.company});
  @override
  _PayBillScreenState createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();
  final accountNumberController = TextEditingController();

  double billAmount = 0.0;
  double amount = 0.0;
  double enteredAmount = 0.0;
  bool isLoading = false;

  final userId = FirebaseAuth.instance.currentUser.uid;

  var initialUserData;

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    initialUserData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> makeBillHistory() async {
    await FirebaseFirestore.instance
        .collection('transactionHistory')
        .doc('bvPG11Sba8DrOS1U0bwT')
        .collection('users')
        .doc(userId)
        .collection('history')
        .add({
      'companyName': widget.company.name,
      'companyPic': widget.company.pic,
      'amountPaid': billAmount.toString(),
      'time': Timestamp.now(),
    });
  }

  Future<void> saveCompanyForm() async {
    final companyForm = await FirebaseFirestore.instance
        .collection('savedCompanies')
        .doc(userId)
        .collection('companies')
        .doc(widget.company.id)
        .set({
      'id': widget.company.id,
      'companyName': widget.company.name,
      'companyPic': widget.company.pic,
      'amountPaid': billAmount.toString(),
      'firstName': firstNameController.text,
      'secondName': secondNameController.text,
      'email': emailController.text,
      'address': addressController.text,
      'postCode': postCodeController.text,
      'accountNumer': accountNumberController.text,
      'time': Timestamp.now(),
    });
  }

  Future deductAccountBalance() async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'email': initialUserData['email'],
      'userId': initialUserData['userId'],
      'userName': initialUserData['userName'],
      'walletBalance':
          (double.parse(initialUserData['walletBalance']) - billAmount)
              .toString(),
    });
  }

  payTheBill() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    try {
      setState(() {
        isLoading = true;
      });

      _formKey.currentState.reset();

      await makeBillHistory();
      await saveCompanyForm();
      await deductAccountBalance();

      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment Successfully Done',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    } on FirebaseException catch (e) {
      print('${e.message}--------------------------platform error');
      showDialog(
        context: context,
        builder: (_) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text("Error"),
            content: Text(e.message),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      );
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        title: Text('Pay your Bills'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Image.network(
                        widget.company.pic,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '${widget.company.name} :',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Fill the Form To Pay the Bill :',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 5, bottom: 5),
                                child: TextFormField(
                                  controller: firstNameController,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'First Name',
                                    border: InputBorder.none,
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a valid name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 5, bottom: 5),
                                child: TextFormField(
                                  controller: secondNameController,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'Second Name',
                                    border: InputBorder.none,
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a valid name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 5, bottom: 5),
                                child: TextFormField(
                                  controller: emailController,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    border: InputBorder.none,
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid email';
                                    }
                                    if (!value.contains('@') ||
                                        !value.contains('.')) {
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 5, bottom: 5),
                                child: TextFormField(
                                  controller: addressController,
                                  keyboardType: TextInputType.streetAddress,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'Address',
                                    border: InputBorder.none,
                                  ),
                                  onSaved: (value) {
                                    //password = value;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid Address';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 5, bottom: 5),
                                child: TextFormField(
                                  controller: postCodeController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'Post Code',
                                    border: InputBorder.none,
                                  ),
                                  onSaved: (value) {
                                    //password = value;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid PostCode';
                                    }
                                    if (value.length < 6) {
                                      return 'Post Code must be 5 characters long';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 5, bottom: 5),
                                child: TextFormField(
                                  controller: accountNumberController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'Account Number',
                                    border: InputBorder.none,
                                  ),
                                  onSaved: (value) {
                                    //password = value;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid Account Number';
                                    }
                                    if (value.length < 10) {
                                      return 'Account Number must be 10 characters long';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 5, bottom: 5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'Enter the Bill amount \$',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (va) {
                                    setState(() {
                                      enteredAmount = double.parse(va);
                                      billAmount = (enteredAmount +
                                          (enteredAmount * 0.02));
                                      amount = billAmount;
                                    });
                                  },
                                  onSaved: (value) {
                                    enteredAmount = double.parse(value);
                                    billAmount = (enteredAmount +
                                        (enteredAmount * 0.02));
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid amount';
                                    }
                                    if (double.parse(value) >
                                        double.parse(
                                            initialUserData['walletBalance'])) {
                                      return 'Not enough Balance';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              child: Text(
                                'Including 2% Tax',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'You will Pay',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${amount.toString()} \$',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                payTheBill();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Click To Pay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
