import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makatrading/clientlist.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  String? _name, _number, _email, _referredBy;
  String _confirmPassword = '';

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_passwordController.text != _confirmPassword) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Passwords do not match")));
        return;
      }

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _email!, password: _passwordController.text);
        User? user = userCredential.user;

        if (user != null) {
          String userId = user.uid; // Generate the unique userId

          await _firestore.collection('users').doc(userId).set({
            'userId': userId, // Add the userId field
            'name': _name,
            'number': _number,
            'email': _email,
            'referredBy': _referredBy,
          });

          Navigator.pop(context, {
            'success': true,
            'name': _name, // Pass the client's name back to the ClientListPage
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/makatradinglogo.jpeg',
                  height: 100, width: 100),
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Enter Full Name' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Contact Number' : null,
                onSaved: (value) => _number = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter Email' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) => value != _passwordController.text
                    ? 'Passwords do not match'
                    : null,
                onSaved: (value) => _confirmPassword = value!,
                obscureText: true,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Referred by (Full Name)'),
                validator: (value) => value!.isEmpty
                    ? 'Enter Full Name of the person who referred you'
                    : null,
                onSaved: (value) => _referredBy = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                child: Text('Create Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
