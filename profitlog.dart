import 'package:flutter/material.dart';

class InternalProfitLogPage extends StatelessWidget {
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
                    'Internal Profit Log',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          'Profit',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Client Account',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('2023-05-31')),
                          DataCell(Text('R500,000')),
                          DataCell(Text('John Snow')),
                        ],
                      ),
                      // Add more DataRow widgets for each client.
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
