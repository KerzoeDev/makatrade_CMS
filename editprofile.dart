import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:makatrading/clientlist.dart' as ClientListPage;
import 'package:makatrading/main.dart';
import 'package:makatrading/profitlog.dart';
import 'package:makatrading/signin.dart';

class EditProfilePage extends StatefulWidget {
  final DocumentSnapshot client;

  EditProfilePage({required this.client}) {
    print(client.data());
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController totalReferralsController;
  late TextEditingController verificationStatusController;
  late TextEditingController growthPercentageAndPackageController;

  String? _depositDate;
  double? _depositAmount;
  String? _profitDate;
  double? _profitAmount;
  String? _withdrawalDate;
  double? _withdrawalAmount;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client['name']);
    emailController = TextEditingController(text: widget.client['email']);
    phoneNumberController =
        TextEditingController(text: widget.client['phoneNumber']);
    totalReferralsController =
        TextEditingController(text: widget.client['totalReferrals'].toString());
    verificationStatusController =
        TextEditingController(text: widget.client['verificationStatus']);
    growthPercentageAndPackageController = TextEditingController(
        text:
            '${widget.client['growthPercentage']}% - ${widget.client['package']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  // ... your code here ...
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                            ),
                            controller: nameController,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            controller: emailController,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                            ),
                            controller: phoneNumberController,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Verification Status',
                            ),
                            controller: verificationStatusController,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Total Referrals',
                            ),
                            controller: totalReferralsController,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Growth % and Package',
                            ),
                            controller: growthPercentageAndPackageController,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              // TODO: Update Firestore here with new values.
                              await widget.client.reference.update({
                                'name': nameController.text,
                                'email': emailController.text,
                                'phoneNumber': phoneNumberController.text,
                                'verificationStatus':
                                    verificationStatusController.text,
                                'totalReferrals': int.tryParse(
                                        totalReferralsController.text) ??
                                    0,
                                'growthPercentage': double.tryParse(
                                        growthPercentageAndPackageController
                                            .text
                                            .split('%')[0]) ??
                                    0,
                                'package': growthPercentageAndPackageController
                                    .text
                                    .split('-')[1]
                                    .trim(),
                              });
                            },
                            child: Text('Save Changes'),
                          ),
                          SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Deposit',
                                      style: TextStyle(fontSize: 24)),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Deposit Date'),
                                    onChanged: (value) {
                                      _depositDate = value;
                                    },
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Deposit Amount',
                                      prefixText: 'R',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _depositAmount = double.tryParse(value);
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Save the deposit to Firestore
                                      User? user = _auth.currentUser;
                                      if (user != null &&
                                          _depositDate != null &&
                                          _depositAmount != null) {
                                        await _firestore
                                            .collection('users')
                                            .doc(user.uid)
                                            .collection('deposits')
                                            .add({
                                          'depositDate': _depositDate,
                                          'depositAmount': _depositAmount,
                                        });
                                      }
                                    },
                                    child: Text('Add to log'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Profit',
                                      style: TextStyle(fontSize: 24)),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Profit Date'),
                                    onChanged: (value) {
                                      _profitDate = value;
                                    },
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Profit Amount',
                                      prefixText: 'R',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _profitAmount = double.tryParse(value);
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Save the profit to Firestore
                                      User? user = _auth.currentUser;
                                      if (user != null &&
                                          _profitDate != null &&
                                          _profitAmount != null) {
                                        await _firestore
                                            .collection('users')
                                            .doc(user.uid)
                                            .collection('profits')
                                            .add({
                                          'profitDate': _profitDate,
                                          'profitAmount': _profitAmount,
                                        });
                                      }
                                    },
                                    child: Text('Add to log'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Withdrawal',
                                      style: TextStyle(fontSize: 24)),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Withdrawal Date'),
                                    onChanged: (value) {
                                      _withdrawalDate = value;
                                    },
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Withdrawal Amount',
                                      prefixText: 'R',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _withdrawalAmount =
                                          double.tryParse(value);
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Save the withdrawal to Firestore
                                      User? user = _auth.currentUser;
                                      if (user != null &&
                                          _withdrawalDate != null &&
                                          _withdrawalAmount != null) {
                                        await _firestore
                                            .collection('users')
                                            .doc(user.uid)
                                            .collection('withdrawals')
                                            .add({
                                          'withdrawalDate': _withdrawalDate,
                                          'withdrawalAmount': _withdrawalAmount,
                                        });
                                      }
                                    },
                                    child: Text('Add to log'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]))));
  }
}
