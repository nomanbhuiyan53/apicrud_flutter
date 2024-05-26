import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addproductInProgress = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Store Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key:_formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if(value == null || value.trim().isEmpty){
                      return 'Write your product name';
                    }
                    return null;
                  } ,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _codeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Code',
                  ),
                    validator: (String? value) {
                      if(value == null || value.trim().isEmpty){
                        return 'Write your product Code';
                      }
                      return null;
                    },
                ),

                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _unitPriceController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Unit Price',
                  ),
                    validator: (String? value) {
                      if(value == null || value.trim().isEmpty){
                        return 'Write your product Unit Price';
                      }
                      return null;
                    },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                  ),
                    validator: (String? value) {
                      if(value == null || value.trim().isEmpty){
                        return 'Write your product Quantity';
                      }
                      return null;
                    },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _totalPriceController,
                    keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Price',
                  ),
                    validator: (String? value) {
                      if(value == null || value.trim().isEmpty){
                        return 'Write your product Total Price';
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _createdDateController,
                      decoration: const InputDecoration(
                        labelText: 'Created Date',
                      ),
                        validator: (String? value) {
                          if(value == null || value.trim().isEmpty){
                            return 'Pick Your Date';
                          }
                          return null;
                        },
                    ),
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
                  Visibility(
                    visible: _addproductInProgress == false,
                    replacement:const Center(
                      child: CircularProgressIndicator(),
                    ) ,
                    child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _productStore();
                      }
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _createdDateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _productStore() async{
    bool _addproductInProgress = true;
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
    Response response = await post(uri,body: jsonEncode(data) ,headers: {'Content-Type':'application/json'});
    print(response.statusCode);
    if(response.statusCode == 200){
      _nameController.clear();
      _codeController.clear();
      _imageController.clear();
      _unitPriceController.clear();
      _qtyController.clear();
      _totalPriceController.clear();
      _createdDateController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product store success')));
      Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Product failed ! Try Aging')));
    }
    setState(() {
    });
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
