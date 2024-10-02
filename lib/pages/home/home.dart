import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final CollectionReference menuCollection = FirebaseFirestore.instance.collection('menu');
  String? selectedMenuItemId;

  Future<void> addItem(String name, String description, double price) async {
    await menuCollection.add({
      'name': name,
      'description': description,
      'price': price,
    });
  }

  Future<void> updateItem(String id, String name, String description, double price) async {
    await menuCollection.doc(id).update({
      'name': name,
      'description': description,
      'price': price,
    });
  }

  Future<void> deleteItem(String id) async {
    await menuCollection.doc(id).delete();
  }

  void clearFields() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    setState(() {
      selectedMenuItemId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menu.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (selectedMenuItemId == null) {
                          addItem(
                            nameController.text,
                            descriptionController.text,
                            double.parse(priceController.text),
                          );
                        } else {
                          updateItem(
                            selectedMenuItemId!,
                            nameController.text,
                            descriptionController.text,
                            double.parse(priceController.text),
                          );
                        }
                        clearFields();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Save'),
                    ),
                    if (selectedMenuItemId != null)
                      ElevatedButton(
                        onPressed: () {
                          deleteItem(selectedMenuItemId!);
                          clearFields();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: menuCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                document['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document['description']),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${document['price']}',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  selectedMenuItemId = document.id;
                                  nameController.text = document['name'];
                                  descriptionController.text = document['description'];
                                  priceController.text = document['price'].toString();
                                });
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
