import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:makatrading/signin.dart' as SignInPage;
import 'package:makatrading/clientlist.dart' as ClientListPage;
import 'package:makatrading/profitlog.dart' as InternalProfitLogPage;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:async/async.dart';
import 'package:makatrading/withdrawalrequests.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBsxsUhI8FppeeITHAE4TvzB2HFN8A3Kvc",
        authDomain: "makatrade.firebaseapp.com",
        databaseURL:
            "https://makatrade-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "makatrade",
        storageBucket: "makatrade.appspot.com",
        messagingSenderId: "504475759309",
        appId: "1:504475759309:web:6b6f6834a24715ca1b6f84",
        measurementId: "G-T9Q2YXH6ZW"),
  );

  runApp(App());
}

class Data {
  Data(this.month, this.value);

  final DateTime month;
  final double value;
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error initializing Firebase'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maka Trading',
      theme: ThemeData.light(),
      home: SignInPage.SignInCMS(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Data> _chartData = [];
  int _totalClients = 0;

  List<String> allMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _chartData = [];

    final QuerySnapshot snapshot = await _firestore
        .collection('monthly_users')
        .orderBy(FieldPath.documentId)
        .get();

    if (snapshot.docs.isEmpty) {
      print('No data found in monthly_users collection');
      return;
    }

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      if (!data.containsKey('count')) {
        print('count field not found in the document');
        continue;
      }

      final count = data['count'] ?? 0;

      if (doc.id.length != 7 || !doc.id.contains('-')) {
        print('Document ID is not in expected format YYYY-MM');
        continue;
      }

      final yearMonth = doc.id.split('-');
      final date = DateTime(int.parse(yearMonth[0]), int.parse(yearMonth[1]));
      _chartData.add(Data(date, count.toDouble()));

      // print the data for debugging
      print('Added data: ${date.toString()}, ${count.toDouble()}');
    }

    setState(() {
      _totalClients =
          _chartData.map((data) => data.value.toInt()).reduce((a, b) => a + b);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                Image.asset('assets/images/makatradinglogo.jpeg'),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Clients'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ClientListPage.ClientListPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt_long),
                  title: Text('Internal Profit Log'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InternalProfitLogPage.InternalProfitLogPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.money),
                  title: Text('Withdrawal Requests'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WithdrawalRequestsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage.SignInCMS(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Dashboard',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      color: Color(0xFFF0F4FF),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '$_totalClients Total Clients',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat('MMM'),
                        intervalType: DateTimeIntervalType.months,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        numberFormat: NumberFormat('#,##0'),
                        labelIntersectAction: AxisLabelIntersectAction.hide,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      series: <ChartSeries>[
                        LineSeries<Data, DateTime>(
                          dataSource: _chartData,
                          xValueMapper: (Data data, _) => data.month,
                          yValueMapper: (Data data, _) => data.value,
                          width: 2, // Adjust the width of the spline line
                          color: Colors
                              .blue, // Change the color of the spline line
                          markerSettings: MarkerSettings(isVisible: false),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension IterableExtensions<T> on Iterable<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}
