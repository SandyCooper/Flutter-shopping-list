import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final formKey = GlobalKey<FormState>();
  var enteredName = "";
  var enteredQuantity = 1;
  var selectedCategory = categories[Categories.vegetables]!;
  var isSending = false;

  void saveItem() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isSending = true;
      });
      final url = Uri.https("flutter-test-63344-default-rtdb.firebaseio.com",
          "shopping-List.json");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": enteredName,
          "quantity": enteredQuantity,
          "category": selectedCategory.category,
        }),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        GroceryItem(
          id: resData["name"],
          name: enteredName,
          quantity: enteredQuantity,
          category: selectedCategory,
        ),
      );

      // Navigator.of(context).pop(GroceryItem(
      //   id: DateTime.now().toString(),
      //   name: enteredName,
      //   quantity: enteredQuantity,
      //   category: selectedCategory,
      // ));
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must between 1 t0 50 characters.";
                  }
                  return null;
                },
                onSaved: (value) {
                  enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        initialValue: enteredQuantity.toString(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! < 1 ||
                              value.trim().length > 50) {
                            return "Must be positive number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enteredQuantity = int.parse(value!);
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(category.value.category),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            formKey.currentState!.reset();
                          },
                    child: const Text("Reset"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: isSending ? null : saveItem,
                    child: isSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Add Item"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
