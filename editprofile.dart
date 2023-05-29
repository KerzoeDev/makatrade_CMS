import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
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
                    'Edit Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
