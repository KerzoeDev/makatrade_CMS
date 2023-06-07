import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makatrading/profitlog.dart';
import 'package:makatrading/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:makatrading/createclient.dart';
import 'package:makatrading/editprofile.dart';
import 'package:makatrading/signin.dart';

class ClientListPage extends StatefulWidget {
  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  final _clientsPerPage = 10;
  List<DocumentSnapshot> _clients = [];
  DocumentSnapshot? _lastDocument;
  bool _loadingClients = true;
  bool _allClientsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadClients();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_allClientsLoaded) {
        _loadClients();
      }
    });
  }

  Future<void> _loadClients() async {
    if (_allClientsLoaded) return;
    Query query =
        _firestore.collection('users').orderBy('name').limit(_clientsPerPage);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    final clientsSnapshot = await query.get();
    if (clientsSnapshot.docs.length < _clientsPerPage) {
      _allClientsLoaded = true;
    }
    _lastDocument = clientsSnapshot.docs.last;
    setState(() {
      _clients.addAll(clientsSnapshot.docs);
      _loadingClients = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Client List'),
        ),
        body: Row(children: [
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
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
                      MaterialPageRoute(builder: (context) => ClientListPage()),
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
                        builder: (context) => InternalProfitLogPage(),
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
                      MaterialPageRoute(builder: (context) => SignInCMS()),
                    );
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _clients.length,
              itemBuilder: (context, index) {
                final client = _clients[index];
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${client['name']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Email: ${client['email']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Phone: ${client['number']}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'view',
                          child: ListTile(
                            leading: Icon(Icons.visibility),
                            title: Text('View Client'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit Client'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete Client'),
                          ),
                        ),
                      ],
                      onSelected: (String value) {
                        if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Delete'),
                                content: Text('Are you sure?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Add your delete function here
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (value == 'view' || value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(client: client),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
