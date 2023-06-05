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

  EditProfilePage({required this.client});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String name;
  late String email;
  late String phoneNumber;
  late int totalReferrals;
  late String verificationStatus;
  late double growthPercentage;
  late String package;

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
  void initState() {
    super.initState();
    name = widget.client['name'];
    email = widget.client['email'];
    phoneNumber = widget.client['phoneNumber'];
    totalReferrals = widget.client['totalReferrals'];
    verificationStatus = widget.client['verificationStatus'];
    growthPercentage = widget.client['growthPercentage'];
    package = widget.client['package'];
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(),
                          ),
                        );
                      },
                      child: Text('Dashboard'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientListPage.ClientListPage(),
                          ),
                        );
                      },
                      child: Text('Clients'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InternalProfitLogPage(),
                          ),
                        );
                      },
                      child: Text('Internal Profit Log'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInCMS(),
                          ),
                        );
                      },
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
                        controller: TextEditingController(
                          text: name,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        controller: TextEditingController(
                          text: email,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        controller: TextEditingController(
                          text: phoneNumber,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Verification Status',
                        ),
                        controller: TextEditingController(
                          text: verificationStatus,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Total Referrals',
                        ),
                        controller: TextEditingController(
                          text: totalReferrals.toString(),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Growth % and Package',
                        ),
                        controller: TextEditingController(
                          text: '$growthPercentage% - $package',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Update Firestore here with new values.
                        },
                        child: Text('Save Changes'),
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
