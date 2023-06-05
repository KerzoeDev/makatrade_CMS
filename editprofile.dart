import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? _paymentDate;
  double? _paymentAmount;
  String? _referredBy;
  String? _depositDate;
  double? _depositAmount;
  String? _withdrawalDate;
  double? _withdrawalAmount;
  String? _profitDate;
  double? _profitAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 200,
                color: Colors.blue,
                child: Column(
                  children: [
                    Image.asset('assets/images/makatradinglogo.jpeg'),
                    Text('MakaTrade'),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Dashboard'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Clients'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Internal Profit Log'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
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
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Verification Status',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Total Referrals',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Growth %',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Package',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Save'),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text('Deposit', style: TextStyle(fontSize: 24)),
                              // Add the relevant fields and button as per your requirements
                              // Similar to the Affiliate Payments card
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text('Profit', style: TextStyle(fontSize: 24)),
                              // Add the relevant fields and button as per your requirements
                              // Similar to the Affiliate Payments card
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
                              // Add the relevant fields and button as per your requirements
                              // Similar to the Affiliate Payments card
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text('Affiliate Payments',
                                  style: TextStyle(fontSize: 24)),
                              TextField(
                                decoration:
                                    InputDecoration(labelText: 'Referred By'),
                                onChanged: (value) {
                                  _referredBy = value;
                                },
                              ),
                              TextField(
                                readOnly: true,
                                decoration:
                                    InputDecoration(labelText: 'Payment Date'),
                                onTap: () async {
                                  _paymentDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  setState(() {});
                                },
                                controller: TextEditingController(
                                  text: _paymentDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(_paymentDate!)
                                      : '',
                                ),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Payment Amount',
                                  prefixText: 'R',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _paymentAmount = double.tryParse(value);
                                },
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // Save the affiliate payment to Firestore
                                  User? user = _auth.currentUser;
                                  if (user != null &&
                                      _paymentDate != null &&
                                      _paymentAmount != null &&
                                      _referredBy != null &&
                                      _depositDate != null &&
                                      _depositAmount != null &&
                                      _withdrawalDate != null &&
                                      _withdrawalAmount != null &&
                                      _profitDate != null &&
                                      _profitAmount != null) {
                                    await _firestore
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('affiliatePayments')
                                        .add({
                                      'referredBy': _referredBy,
                                      'paymentDate': _paymentDate,
                                      'paymentAmount': _paymentAmount,
                                      'depositDate': _depositDate,
                                      'depositAmount': _depositAmount,
                                      'withdrawalDate': _withdrawalDate,
                                      'withdrawalAmount': _withdrawalAmount,
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
