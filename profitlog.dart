import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makatrading/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:makatrading/clientlist.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

class InternalProfitLogPage extends StatefulWidget {
  @override
  _InternalProfitLogPageState createState() => _InternalProfitLogPageState();
}

class _InternalProfitLogPageState extends State<InternalProfitLogPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _internalProfitLogs =
      []; // List to store internal profit logs

  @override
  void initState() {
    super.initState();
    _loadInternalProfitLogs(); // Load the internal profit logs when the page is initialized
  }

  Future<void> _loadInternalProfitLogs() async {
    final usersSnapshot = await _firestore.collection('users').get();

    List<Future<void>> futures = [];

    for (final userDoc in usersSnapshot.docs) {
      final profitsSnapshot = await _firestore
          .collection('users')
          .doc(userDoc.id)
          .collection('profits')
          .get();

      futures.addAll(profitsSnapshot.docs.map((profitDoc) async {
        final toDate = (profitDoc['toDate'] as Timestamp).toDate();
        final internalProfit = profitDoc['internalProfit'].toString();
        final clientName = await getClientName(userDoc.id);

        setState(() {
          _internalProfitLogs.add({
            'toDate': toDate,
            'internalProfit': internalProfit,
            'clientName': clientName,
          });
        });
      }));
    }

    await Future.wait(futures);
  }

  Future<String> getClientName(String userId) async {
    final userSnapshot = await _firestore.collection('users').doc(userId).get();
    return userSnapshot.get('name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.blue,
            child: Column(
              children: [
                Image.asset('assets/images/makatradinglogo.jpeg'),
                Text('MakaTrade'),
                SizedBox(height: 10),
                ElevatedButton(
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClientListPage()),
                    );
                  },
                  child: Text('Clients'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InternalProfitLogPage()),
                    );
                  },
                  child: Text('Internal Profit Log'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InternalProfitLogPage()),
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
                    'Internal Profit Log',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'To Date',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Internal Profit',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Client Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: _internalProfitLogs.map((profitLog) {
                      final toDate = profitLog['toDate'] as DateTime;
                      final internalProfit =
                          profitLog['internalProfit'].toString();
                      final clientName = profitLog['clientName'].toString();

                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              DateFormat('yyyy-MM-dd').format(toDate),
                            ),
                          ),
                          DataCell(
                            Text(internalProfit),
                          ),
                          DataCell(
                            Text(clientName),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
