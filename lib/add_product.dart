import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProduct extends StatefulWidget {
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _createdDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Store Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Code',
                ),
              ),

              const SizedBox(height: 16.0),
              TextFormField(
                controller: _unitPriceController,
                decoration: const InputDecoration(
                  labelText: 'Unit Price',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _totalPriceController,
                decoration: const InputDecoration(
                  labelText: 'Total Price',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _createdDateController,
                decoration: const InputDecoration(
                  labelText: 'Created Date',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                  foregroundColor: Colors.white, // Text color
                  shadowColor: Colors.black, // Shadow color
                  elevation: 5, // Elevation of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Padding inside the button
                ),
                child: const Text('Submit'),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _productStore() async{
    String url = 'https://crud.teamrabbil.com/api/v1/CreateProduct';
    Uri uri = Uri.parse(url);
    Map<String,dynamic> data ={
      "Img":_imageController.text,
      "ProductCode":_codeController.text,
      "ProductName":_nameController.text,
      "Qty":_qtyController.text,
      "TotalPrice":_totalPriceController.text,
      "UnitPrice":_unitPriceController.text
    };
    Response response = await post(uri);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _imageController.dispose();
    _unitPriceController.dispose();
    _qtyController.dispose();
    _totalPriceController.dispose();
    _createdDateController.dispose();
    super.dispose();
  }
}
