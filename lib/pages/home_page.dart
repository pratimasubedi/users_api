import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? address;
  final String phone;
  final String website;
  final String? company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.address,
    required this.phone,
    required this.website,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: json['address'] != null
          ? json['address']['street'] +
              ', ' +
              json['address']['suite'] +
              ', ' +
              json['address']['city'] +
              ', ' +
              json['address']['zipcode']
          : null,
      phone: json['phone'],
      website: json['website'],
      company: json['company'] != null ? json['company']['name'] : null,
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];

  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers().then((fetchedUsers) {
      setState(() {
        users = fetchedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'User List API',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                users[index].name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text('Username: ${users[index].username}'),
                  SizedBox(height: 4),
                  Text('Email: ${users[index].email}'),
                  SizedBox(height: 4),
                  Text('Address: ${users[index].address ?? 'N/A'}'),
                  SizedBox(height: 4),
                  Text('Phone: ${users[index].phone}'),
                  SizedBox(height: 4),
                  Text('Website: ${users[index].website}'),
                  SizedBox(height: 4),
                  Text('Company: ${users[index].company ?? 'N/A'}'),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('User Selected'),
                      content: Text(
                        'Name: ${users[index].name}\n\n'
                        'Username: ${users[index].username}\n'
                        'Email: ${users[index].email}\n'
                        'Address: ${users[index].address ?? 'N/A'}\n'
                        'Phone: ${users[index].phone}\n'
                        'Website: ${users[index].website}\n'
                        'Company: ${users[index].company ?? 'N/A'}',
                      ),
                      actions: [
                        TextButton.icon(
                          icon: Icon(Icons.close),
                          label: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: UserListScreen()));
}
