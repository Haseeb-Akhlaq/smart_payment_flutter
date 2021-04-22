import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';

  bool isLoading = false;

  setUpFirebaseUserData(String userId) async {
    final result =
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'userName': username,
      'email': email,
      'userId': userId,
      'walletBalance': '10000',
    });
  }

  registerWithEmail() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    email = email.toString().trim();

    try {
      setState(() {
        isLoading = true;
      });
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        _formKey.currentState.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome $username !!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
        );
        setUpFirebaseUserData(user.user.uid);
        Navigator.pop(context);
      } else {}
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset('assets/logo.png'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 10, top: 5, bottom: 5),
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: 'User Name',
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        username = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter valid name';
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
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        email = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter valid email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
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
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        password = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter valid password';
                        }
                        if (value.length < 6) {
                          return 'Password must be 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        onTap: () {
                          registerWithEmail();
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
                              'Sign UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already Have an account ?  '),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Signin Here',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
