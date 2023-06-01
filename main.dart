import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:makatrading/signin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
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
      home: SignInCMS(),
    );
  }
}

class DashboardPage extends StatelessWidget {
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
                    'Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    color: Color(0xFFF0F4FF),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '20 Total Clients',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Total Clients'),
                    series: <ChartSeries>[
                      SplineSeries<Data, String>(
                        dataSource: [
                          Data('Jan', 35),
                          Data('Feb', 28),
                          Data('Mar', 34),
                          Data('Apr', 32),
                          Data('May', 40),
                          Data('Jun', 45),
                        ],
                        xValueMapper: (Data data, _) => data.month,
                        yValueMapper: (Data data, _) => data.value,
                      ),
                    ],
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

class Data {
  Data(this.month, this.value);

  final String month;
  final double value;
}
