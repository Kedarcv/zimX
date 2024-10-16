import 'dart:io';

import 'package:untitled1/consts/colors.dart';
import 'package:untitled1/services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProductUploadForm extends StatefulWidget {
  // Renamed widget
  static const routeName = '/UploadProductForm';

  @override
  _ProductUploadFormState createState() => _ProductUploadFormState();
}

class _ProductUploadFormState extends State<ProductUploadForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String? _categoryValue;
  String? _brandValue;
  GlobalMethods _globalMethods = GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  String? url;
  var uuid = Uuid();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      if (_pickedImage == null) {
        _globalMethods.authErrorHandle('Please pick an image', context);
      } else {
        setState(() {
          _isLoading = true;
        });
        try {
          await _uploadProduct();
          Navigator.canPop(context) ? Navigator.pop(context) : null;
          _globalMethods.authErrorHandle(
              'Product uploaded successfully!', context);
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), context);
          print('error occurred ${error.toString()}');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _uploadProduct() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('productsImages')
        .child(_titleController.text + '.jpg');
    await ref.putFile(_pickedImage!);
    url = await ref.getDownloadURL();

    final User? user = _auth.currentUser;
    final _uid = user?.uid;
    final productId = uuid.v4();
    await FirebaseFirestore.instance.collection('products').doc(productId).set({
      'productId': productId,
      'productTitle': _titleController.text,
      'price': _priceController.text,
      'productImage': url,
      'productCategory': _categoryController.text,
      'productBrand': _brandController.text,
      'productDescription': _descriptionController.text,
      'productQuantity': _quantityController.text,
      'userId': _uid,
      'createdAt': Timestamp.now(),
    });
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          height: kBottomNavigationBarHeight * 0.8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorsConsts.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            child: InkWell(
              onTap: _trySubmit,
              splashColor: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: _isLoading
                        ? Center(
                            child: Container(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator()))
                        : Text('Upload',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                  ),
                  Icon(
                    Icons.upload,
                    size: 20,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: TextFormField(
                                    key: ValueKey('Title'),
                                    controller: _titleController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a Title';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Product Title',
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  key: ValueKey('Price'),
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Price is missed';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]')), // Allow decimals
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Price',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    image: _pickedImage != null
                                        ? DecorationImage(
                                            image: FileImage(_pickedImage!),
                                            fit: BoxFit.contain,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          _pickImage(ImageSource.camera),
                                      icon: Icon(Icons.camera,
                                          color: Colors.purpleAccent),
                                      label: Text(
                                        'Camera',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .textSelectionTheme
                                              .selectionColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
