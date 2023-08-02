import 'package:flutter/material.dart';
// import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<GroceryItem> groceryItem = [];

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

  void removeItem(GroceryItem item) {
    setState(() {
      groceryItem.remove(item);
    });
  }

  @override
  Widget build(context) {
    Widget content = const Center(child: Text("No items availabe"));

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
