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

  final String month;
  final double value;
}

List<String> categoryNames = [
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
    final usersSnapshot = await _firestore.collection('users').get();

    setState(() {
      _totalClients = usersSnapshot.docs.length;
    });

    final monthlyUsersSnapshot =
        await _firestore.collection('monthly_users').get();

    setState(() {
      _chartData = allMonths.map((month) {
        final doc = monthlyUsersSnapshot.docs
            .where((doc) => doc.id == month)
            .firstOrNull;

        final value = doc?.data()['count']?.toDouble() ?? 0.0;

        return Data(month, value);
      }).toList();
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
                        builder: (context) => ClientListPage.ClientListPage(),
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
                        builder: (context) =>
                            InternalProfitLogPage.InternalProfitLogPage(),
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
                        builder: (context) => SignInPage.SignInCMS(),
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
                      primaryXAxis: CategoryAxis(
                        labelPlacement: LabelPlacement.onTicks,
                        title: AxisTitle(text: 'Months'),
                      ),
                      primaryYAxis: NumericAxis(
                        numberFormat: NumberFormat('#,##0'),
                        labelIntersectAction: AxisLabelIntersectAction.hide,
                        title: AxisTitle(text: 'Total Clients'),
                      ),
                      series: <ChartSeries>[
                        SplineSeries<Data, String>(
                          dataSource: _chartData,
                          xValueMapper: (Data data, _) => data.month,
                          yValueMapper: (Data data, _) => data.value,
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
