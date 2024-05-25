import 'dart:convert';

import 'package:api_prectice/add_product.dart';
import 'package:api_prectice/product_item.dart';
import 'package:api_prectice/update_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  get separatorBuilder => null;
  bool _getProductList = false;
  List<Products> productItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: _productList,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                   final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddProduct(),
                      ),
                    );
                   if(result){
                     _productList();
                   }
                  },
                  child: const Row(
                    children: [ Icon(Icons.add), Text('Add New Product')],
                  )),
            ),
            const Divider(),
            Expanded(
              child: Visibility(
                visible: _getProductList == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.separated(
                  itemCount: productItem.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return _productListView(productItem[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _productListView(Products products) {
    return ListTile(
      title: Text(products.name),
      subtitle: Wrap(spacing: 16, children: [
        Text('Unit Price: ${products.unitPrice}'),
        Text('Quantity: ${products.qty}'),
        Text('Total Price: ${products.totalPrice}')
      ]),
      leading: SizedBox(
        height: 50,
        child: Image.network(products.image),
      ),
      trailing: Wrap(
        children: [
          IconButton(onPressed: () async {
           final result = await  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProduct(products: products),));
           if(result){
             _productList();
           }
          }, icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () {
              _confirmDelete(products);
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }

  Future<void> _productList() async {
    _getProductList = true;
    productItem.clear();
    const String productURL = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(productURL);
    Response response = await get(uri);
    if (response.statusCode == 200) {
      // decode
      final decodData = jsonDecode(response.body);
      // list
      final productlist = decodData['data'];
      // loop
      for (Map<String, dynamic> p in productlist) {
        Products products = Products(
            p['ProductName'] ?? '',
            p['_id'] ?? '',
            p['ProductCode'] ?? '',
            p['Img'] ?? '',
            p['UnitPrice'] ?? '',
            p['Qty'] ?? '',
            p['TotalPrice'] ?? '',
            p['CreatedDate'] ?? '');
        productItem.add(products);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product data get fail! Try Again.')),
      );
    }
    _getProductList = false;
    setState(() {});
  }

  Future<void> _deleteProduct(String? id) async {
    setState(() {
      _getProductList = true;
    });
    String url = 'https://crud.teamrabbil.com/api/v1/DeleteProduct/$id';
    Uri uri = Uri.parse(url);
    final response = await get(uri);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Delete success.')),
      );
      // Refresh the product list after deletion
      _productList();
    } else {
      // Handle error
      final errorData = jsonDecode(response.body);
      print('Failed to delete product: ${errorData['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete product: ${errorData['message']}')),
      );
    }
    setState(() {
      _getProductList = false;
    });
  }

  Future<void> _confirmDelete(Products product) async {
    final confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _deleteProduct(product.id);
    }
  }
}
