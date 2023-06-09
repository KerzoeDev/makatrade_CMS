import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makatrading/clientlist.dart';
import 'package:makatrading/main.dart';
import 'package:makatrading/profitlog.dart';
import 'package:makatrading/signin.dart';

class WithdrawalRequestsPage extends StatefulWidget {
  @override
  _WithdrawalRequestsPageState createState() => _WithdrawalRequestsPageState();
}

class _WithdrawalRequestsPageState extends State<WithdrawalRequestsPage> {
  bool _isPendingRequests = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _toggleRequests(bool isPending) {
    setState(() {
      _isPendingRequests = isPending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Withdrawal Requests'),
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                Image.asset('assets/images/makatradinglogo.jpeg'),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage()),
                    );
                  },
                  child: Text('Dashboard'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientListPage(),
                      ),
                    );
                  },
                  child: Text('Clients'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
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
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
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
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WithdrawalRequestsPage(),
                      ),
                    );
                  },
                  child: Text('Withdrawal Requests'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                _isPendingRequests ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            _toggleRequests(true);
                          },
                          child: Text('Pending Withdrawal Requests'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                !_isPendingRequests ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            _toggleRequests(false);
                          },
                          child: Text('Completed Withdrawal Requests'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isPendingRequests
                      ? _buildPendingRequestsList()
                      : _buildCompletedRequestsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('withdrawalRequests')
          .doc('pending')
          .collection('requests')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final clientName =
                  (request.data() as Map<String, dynamic>)['name'];
              final email = (request.data() as Map<String, dynamic>)['email'];
              final withdrawalAmount = (request.data()
                  as Map<String, dynamic>)['withdrawalRequestAmount'];
              final documentId = request.id; // Get the document ID

              return _buildRequestCard(
                clientName: clientName ?? '',
                email: email ?? '',
                withdrawalAmount: withdrawalAmount ?? '',
                documentId: documentId, // Pass the document ID
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildCompletedRequestsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('withdrawalRequests')
          .doc('completed')
          .collection('requests')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final clientName =
                  (request.data() as Map<String, dynamic>)['name'];
              final email = (request.data() as Map<String, dynamic>)['email'];
              final withdrawalAmount = (request.data()
                  as Map<String, dynamic>)['withdrawalRequestAmount'];
              final documentId = request.id; // Get the document ID

              return _buildRequestCard(
                clientName: clientName ?? '',
                email: email ?? '',
                withdrawalAmount: withdrawalAmount ?? '',
                documentId: documentId, // Pass the document ID
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildRequestCard({
    required String clientName,
    required String email,
    required String withdrawalAmount,
    required String documentId,
  }) {
    bool isChecked = false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) async {
              setState(() {
                isChecked = value ?? false;
              });

              if (isChecked) {
                // Transfer to Completed Withdrawal Requests
                FirebaseFirestore.instance
                    .collection('withdrawalRequests')
                    .doc('completed')
                    .collection('requests')
                    .doc(documentId)
                    .set({
                  'name': clientName,
                  'email': email,
                  'withdrawalRequestAmount': withdrawalAmount,
                });

                // Remove from Pending Withdrawal Requests
                FirebaseFirestore.instance
                    .collection('withdrawalRequests')
                    .doc('pending')
                    .collection('requests')
                    .doc(documentId)
                    .delete();
              }
            },
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Client Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  clientName,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Withdrawal Request Amount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  withdrawalAmount,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
