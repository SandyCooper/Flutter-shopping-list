import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
// import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<GroceryItem> groceryItem = [];
  var isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  void loadItem() async {
    final url = Uri.https(
        "flutter-test-63344-default-rtdb.firebaseio.com", "shopping-List.json");
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          error = "Failed to fetch data, Please try again later.";
        });
      }

      if (response.body == "null") {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItem = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.category == item.value["category"])
            .value;
        loadedItem.add(
          GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: category,
          ),
        );
      }

      setState(() {
        groceryItem = loadedItem;
        isLoading = false;
      });
    } catch (err) {
      setState(() {
          error = "Something went wrong, Please try again later.";
        });
    }
  }

  void addItem() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      groceryItem.add(newItem);
    });
  }

  void removeItem(GroceryItem item) async {
    final index = groceryItem.indexOf(item);
    setState(() {
      groceryItem.remove(item);
    });
    final url = Uri.https("flutter-test-63344-default-rtdb.firebaseio.com",
        "shopping-List/${item.id}.json");
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        groceryItem.insert(index, item);
      });
    }
  }

  @override
  Widget build(context) {
    Widget content = const Center(child: Text("No items availabe"));

    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (groceryItem.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItem.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            removeItem(groceryItem[index]);
          },
          key: ValueKey(groceryItem[index].id),
          child: ListTile(
            title: Text(groceryItem[index].name),
            leading: Container(
              width: 20,
              height: 20,
              color: groceryItem[index].category.color,
            ),
            trailing: Text(
              groceryItem[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: addItem,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: content,
      // Column(
      //   children: [
      //     for(final groceryItem in groceryItems)
      //     Card(child: Padding(padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      //       child: Row(children: [
      //         Container(width: 10, height: 10, color: groceryItem.category.color,),
      //         const SizedBox(width: 25,),
      //         Text(groceryItem.name),
      //         const  Spacer(),
      //         Text(groceryItem.quantity.toString()),
      //       ],),
      //     ),),
      //   ],
      // ),
    );
  }
}
