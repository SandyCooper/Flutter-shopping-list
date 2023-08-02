import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widget/new_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  void addItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
  }

  @override
  Widget build(context) {
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(groceryItems[index].name),
          leading: Container(
            width: 20,
            height: 20,
            color: groceryItems[index].category.color,
          ),
          trailing: Text(
            groceryItems[index].quantity.toString(),
          ),
        ),
      ),
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
