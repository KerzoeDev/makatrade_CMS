import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final DocumentSnapshot client;

  EditProfilePage({required this.client});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController numberController;

  DateTime? _depositDate;
  double? _depositAmount;
  DateTime? _profitFromDate;
  DateTime? _profitToDate;
  double? _profitAmount;
  double? _internalProfit;
  DateTime? _withdrawalDate;
  double? _withdrawalAmount;

  List<Map<String, dynamic>> profitLogs = [];
  List<Map<String, dynamic>> depositLogs = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client['name']);
    emailController = TextEditingController(text: widget.client['email']);
    numberController = TextEditingController(text: widget.client['number']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) setDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        setDate(picked);
      });
    }
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
                controller: nameController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                controller: emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                controller: numberController,
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
                  labelText: 'Growth % and Package',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await widget.client.reference.update({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phoneNumber': numberController.text,
                  });
                },
                child: Text('Save Changes'),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Deposit',
                        style: TextStyle(fontSize: 24),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Deposit Date',
                        ),
                        onTap: () => _selectDate(context, (date) {
                          setState(() {
                            _depositDate = date;
                          });
                        }),
                        controller: TextEditingController(
                          text: _depositDate != null
                              ? _depositDate.toString()
                              : '',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Deposit Amount',
                          prefixText: 'R',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _depositAmount = double.tryParse(value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_depositDate != null && _depositAmount != null) {
                            var depositLog = {
                              'depositDate': _depositDate,
                              'depositAmount': _depositAmount,
                            };
                            setState(() {
                              depositLogs.add(depositLog);
                            });
                            await widget.client.reference
                                .collection('deposits')
                                .add(depositLog);
                          }
                        },
                        child: Text('Add to log'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: depositLogs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Date: ${depositLogs[index]['depositDate'].toString()}'),
                            subtitle: Text(
                                'Amount: R${depositLogs[index]['depositAmount'].toString()}'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Profit',
                        style: TextStyle(fontSize: 24),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'From Date',
                        ),
                        onTap: () => _selectDate(context, (date) {
                          setState(() {
                            _profitFromDate = date;
                          });
                        }),
                        controller: TextEditingController(
                          text: _profitFromDate != null
                              ? _profitFromDate.toString()
                              : '',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'To Date',
                        ),
                        onTap: () => _selectDate(context, (date) {
                          setState(() {
                            _profitToDate = date;
                          });
                        }),
                        controller: TextEditingController(
                          text: _profitToDate != null
                              ? _profitToDate.toString()
                              : '',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Profit Amount',
                          prefixText: 'R',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _profitAmount = double.tryParse(value);
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Internal Profit',
                          prefixText: 'R',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _internalProfit = double.tryParse(value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_profitFromDate != null &&
                              _profitToDate != null &&
                              _profitAmount != null &&
                              _internalProfit != null) {
                            var profitLog = {
                              'fromDate': _profitFromDate,
                              'toDate': _profitToDate,
                              'profitAmount': _profitAmount,
                              'internalProfit': _internalProfit,
                            };
                            setState(() {
                              profitLogs.add(profitLog);
                            });
                            await widget.client.reference
                                .collection('profits')
                                .add(profitLog);
                          }
                        },
                        child: Text('Add to log'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: profitLogs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'From: ${profitLogs[index]['fromDate'].toString()} - To: ${profitLogs[index]['toDate'].toString()}'),
                            subtitle: Text(
                                'Profit: R${profitLogs[index]['profitAmount'].toString()}'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Withdrawal',
                        style: TextStyle(fontSize: 24),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Withdrawal Date',
                        ),
                        onTap: () => _selectDate(context, (date) {
                          setState(() {
                            _withdrawalDate = date;
                          });
                        }),
                        controller: TextEditingController(
                          text: _withdrawalDate != null
                              ? _withdrawalDate.toString()
                              : '',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Withdrawal Amount',
                          prefixText: 'R',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _withdrawalAmount = double.tryParse(value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_withdrawalDate != null &&
                              _withdrawalAmount != null) {
                            await widget.client.reference
                                .collection('withdrawals')
                                .add({
                              'withdrawalDate': _withdrawalDate,
                              'withdrawalAmount': _withdrawalAmount,
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
    );
  }
}
