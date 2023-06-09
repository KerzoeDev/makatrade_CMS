import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:makatrading/signin.dart' as SignInPage;
import 'package:makatrading/clientlist.dart' as ClientListPage;
import 'package:makatrading/profitlog.dart' as InternalProfitLogPage;
import 'package:makatrading/main.dart';
import 'package:makatrading/withdrawalrequests.dart';

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
  late TextEditingController referredByController;
  late TextEditingController affiliatePaymentDateController;
  late TextEditingController affiliateAmountController;
  late TextEditingController verificationStatusController;
  late TextEditingController totalReferralsController;
  late TextEditingController growthPackageController;

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
  List<Map<String, dynamic>> affiliatePayments = [];

  DateTime? _affiliatePaymentDate;
  double? _affiliateAmount;
  String? _verificationStatus;
  int? _totalReferrals;
  String? _growthPackage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client['name']);
    emailController = TextEditingController(text: widget.client['email']);
    numberController = TextEditingController(text: widget.client['number']);
    referredByController =
        TextEditingController(text: widget.client['referredBy']);
    affiliatePaymentDateController = TextEditingController();
    affiliateAmountController = TextEditingController();
    verificationStatusController = TextEditingController();
    totalReferralsController = TextEditingController();
    growthPackageController = TextEditingController();

    _loadDepositLogs();
    _loadProfitLogs();
    _loadWithdrawalLogs();
    _loadInternalProfitLogs();

    _verificationStatus =
        (widget.client.data() as Map<String, dynamic>)['verificationStatus'] ??
            '';
    _totalReferrals =
        (widget.client.data() as Map<String, dynamic>)['totalReferrals'] ?? 0;
    _growthPackage =
        (widget.client.data() as Map<String, dynamic>)['growthPackage'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
    referredByController.dispose();
    affiliatePaymentDateController.dispose();
    affiliateAmountController.dispose();
    verificationStatusController.dispose();
    totalReferralsController.dispose();
    growthPackageController.dispose();
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Edit Profile',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      controller: verificationStatusController,
                      onChanged: (value) {
                        setState(() {
                          _verificationStatus = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Total Referrals',
                      ),
                      controller: totalReferralsController,
                      onChanged: (value) {
                        setState(() {
                          _totalReferrals = int.tryParse(value);
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Growth % and Package',
                      ),
                      controller: growthPackageController,
                      onChanged: (value) {
                        setState(() {
                          _growthPackage = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await widget.client.reference.update({
                            'name': nameController.text,
                            'email': emailController.text,
                            'phoneNumber': numberController.text,
                            'verificationStatus': _verificationStatus,
                            'totalReferrals': _totalReferrals,
                            'growthPackage': _growthPackage,
                          });
                          setState(() {
                            _name = nameController
                                .text; // Assign the value to _name
                          });
                        } catch (e) {
                          print('Error updating client: $e');
                        }
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
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(_depositDate!)
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
                                try {
                                  if (_depositDate != null &&
                                      _depositAmount != null) {
                                    var depositLog = {
                                      'depositDate':
                                          Timestamp.fromDate(_depositDate!),
                                      'depositAmount': _depositAmount,
                                    };
                                    setState(() {
                                      depositLogs.add(depositLog);
                                    });
                                    await widget.client.reference
                                        .collection('deposits')
                                        .add(depositLog);
                                  }
                                } catch (e) {
                                  print('Error adding deposit log: $e');
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
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(_profitToDate!)
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
                                try {
                                  if (_profitFromDate != null &&
                                      _profitToDate != null &&
                                      _profitAmount != null &&
                                      _internalProfit != null) {
                                    var formattedFromDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(_profitFromDate!);
                                    var formattedToDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(_profitToDate!);

                                    var profitLog = {
                                      'fromDate':
                                          Timestamp.fromDate(_profitFromDate!),
                                      'toDate':
                                          Timestamp.fromDate(_profitToDate!),
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
                                      'fromDate':
                                          Timestamp.fromDate(_profitFromDate!),
                                      'toDate':
                                          Timestamp.fromDate(_profitToDate!),
                                      'profitAmount': _profitAmount,
                                      'internalProfit': _internalProfit,
                                      'userId': widget.client.id,
                                    });
                                  }
                                } catch (e) {
                                  print('Error adding profit log: $e');
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
                                try {
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
                                } catch (e) {
                                  print('Error adding withdrawal log: $e');
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Affiliate Payments',
                              style: TextStyle(fontSize: 24),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Referred By',
                              ),
                              controller: referredByController,
                              enabled: false,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Payment Date',
                              ),
                              onTap: () => _selectDate(context, (date) {
                                setState(() {
                                  _affiliatePaymentDate = date;
                                  affiliatePaymentDateController.text =
                                      DateFormat('yyyy-MM-dd').format(date);
                                });
                              }),
                              controller: affiliatePaymentDateController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Payment Amount',
                                prefixText: 'R',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _affiliateAmount = double.tryParse(value);
                              },
                              controller: affiliateAmountController,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  if (_affiliatePaymentDate != null &&
                                      _affiliateAmount != null) {
                                    var paymentLog = {
                                      'paymentDate': Timestamp.fromDate(
                                          _affiliatePaymentDate!),
                                      'paymentAmount': _affiliateAmount,
                                    };
                                    setState(() {
                                      affiliatePayments.add(paymentLog);
                                    });
                                    await _firestore
                                        .collection('affiliate_payments')
                                        .add(paymentLog);
                                  }
                                } catch (e) {
                                  print('Error adding payment log: $e');
                                }
                              },
                              child: Text('Add to log'),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: affiliatePayments.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      'Date: ${affiliatePayments[index]['paymentDate']}'),
                                  subtitle: Text(
                                      'Amount: R${affiliatePayments[index]['paymentAmount']}'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                    'Are you sure you want to delete this client?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      await widget.client.reference.delete();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          print('Error deleting client: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Text('Delete Client'),
                    ),
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
