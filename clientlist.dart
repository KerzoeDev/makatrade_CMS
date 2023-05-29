import 'package:flutter/material.dart';

class ClientListPage extends StatelessWidget {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Client List',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('New'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF091740),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Search',
                          ),
                        ),
                      ),
                    ],
                  ),
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Phone',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Action',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('John Snow')),
                          DataCell(Text('1234567890')),
                          DataCell(Text('johnsnow@gmail.com')),
                          DataCell(IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          )),
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
