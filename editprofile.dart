import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  String? _name;

  List<Map<String, dynamic>> profitLogs = [];
  List<Map<String, dynamic>> depositLogs = [];
  List<Map<String, dynamic>> withdrawalLogs = [];
  List<Map<String, dynamic>> _internalProfitLogs = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client['name']);
    emailController = TextEditingController(text: widget.client['email']);
    numberController = TextEditingController(text: widget.client['number']);

    _loadDepositLogs();
    _loadProfitLogs();
    _loadWithdrawalLogs();
    _loadInternalProfitLogs();
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

  Future<void> _loadDepositLogs() async {
    final depositSnapshot =
        await widget.client.reference.collection('deposits').get();

    setState(() {
      depositLogs = depositSnapshot.docs.map((doc) {
        final data = doc.data();
        final depositDate = (data['depositDate'] as Timestamp).toDate();
        final formattedDate = DateFormat('yyyy-MM-dd').format(depositDate);
        return {
          'depositDate': formattedDate,
          'depositAmount': data['depositAmount'],
        };
      }).toList();
    });
  }

  Future<void> _loadInternalProfitLogs() async {
    final profitSnapshot =
        await widget.client.reference.collection('profits').get();

    setState(() {
      _internalProfitLogs = profitSnapshot.docs.map((doc) {
        final data = doc.data();
        final toDate = (data['toDate'] as Timestamp).toDate();
        final internalProfit = data['internalProfit'].toString();

        return {
          'toDate': toDate,
          'internalProfit': internalProfit,
        };
      }).toList();
    });
  }

  Future<void> _loadProfitLogs() async {
    final profitSnapshot =
        await widget.client.reference.collection('profits').get();

    setState(() {
      profitLogs = profitSnapshot.docs.map((doc) {
        final data = doc.data();
        final fromDate = (data['fromDate'] as Timestamp).toDate();
        final toDate = (data['toDate'] as Timestamp).toDate();
        final formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
        final formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);

        final profitLog = {
          'fromDate': formattedFromDate,
          'toDate': formattedToDate,
          'profitAmount': data['profitAmount'],
          'internalProfit': data['internalProfit'],
        };

        // Add the new profit log to the internal profit logs list
        _internalProfitLogs.add(profitLog);

        return profitLog;
      }).toList();
    });
  }

  Future<void> _loadWithdrawalLogs() async {
    final withdrawalSnapshot =
        await widget.client.reference.collection('withdrawals').get();

    setState(() {
      withdrawalLogs = withdrawalSnapshot.docs.map((doc) {
        final data = doc.data();
        final withdrawalDate = (data['withdrawalDate'] as Timestamp).toDate();
        final formattedDate = DateFormat('yyyy-MM-dd').format(withdrawalDate);
        return {
          'withdrawalDate': formattedDate,
          'withdrawalAmount': data['withdrawalAmount'],
        };
      }).toList();
    });
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
                  setState(() {
                    _name = nameController.text; // Assign the value to _name
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
                              ? DateFormat('yyyy-MM-dd').format(_depositDate!)
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
                              'depositDate': Timestamp.fromDate(_depositDate!),
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
                                'Date: ${depositLogs[index]['depositDate']}'),
                            subtitle: Text(
                                'Amount: R${depositLogs[index]['depositAmount']}'),
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
                              ? DateFormat('yyyy-MM-dd')
                                  .format(_profitFromDate!)
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
                              ? DateFormat('yyyy-MM-dd').format(_profitToDate!)
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
                          setState(() {
                            _profitAmount = double.tryParse(value);
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Internal Profit',
                          prefixText: 'R',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _internalProfit = double.tryParse(value);
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_profitFromDate != null &&
                              _profitToDate != null &&
                              _profitAmount != null &&
                              _internalProfit != null) {
                            var formattedFromDate = DateFormat('yyyy-MM-dd')
                                .format(_profitFromDate!);
                            var formattedToDate =
                                DateFormat('yyyy-MM-dd').format(_profitToDate!);

                            var profitLog = {
                              'fromDate': Timestamp.fromDate(_profitFromDate!),
                              'toDate': Timestamp.fromDate(_profitToDate!),
                              'profitAmount': _profitAmount,
                              'internalProfit': _internalProfit,
                              'userId': widget.client.id,
                            };
                            setState(() {
                              profitLogs.add(profitLog);
                            });

                            await widget.client.reference
                                .collection('profits')
                                .add({
                              'fromDate': Timestamp.fromDate(_profitFromDate!),
                              'toDate': Timestamp.fromDate(_profitToDate!),
                              'profitAmount': _profitAmount,
                              'internalProfit': _internalProfit,
                              'userId': widget.client.id,
                            });
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
                                'From: ${profitLogs[index]['fromDate']} - To: ${profitLogs[index]['toDate']}'),
                            subtitle: Text(
                                'Profit: R${profitLogs[index]['profitAmount']}'),
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
                              ? DateFormat('yyyy-MM-dd')
                                  .format(_withdrawalDate!)
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
                            var withdrawalLog = {
                              'withdrawalDate':
                                  Timestamp.fromDate(_withdrawalDate!),
                              'withdrawalAmount': _withdrawalAmount,
                            };
                            setState(() {
                              withdrawalLogs.add(withdrawalLog);
                            });
                            await widget.client.reference
                                .collection('withdrawals')
                                .add(withdrawalLog);
                          }
                        },
                        child: Text('Add to log'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: withdrawalLogs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Date: ${withdrawalLogs[index]['withdrawalDate']}'),
                            subtitle: Text(
                                'Amount: R${withdrawalLogs[index]['withdrawalAmount']}'),
                          );
                        },
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
