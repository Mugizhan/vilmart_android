// main.dart (or AddStore.dart)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddStore extends StatefulWidget {
  const AddStore({super.key});

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent[200],
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.store,color: Colors.white),
        ),
        title: const Text('Create Your Store',style: TextStyle(
          color:Colors.white,
          fontWeight: FontWeight.bold
        )),
      ),
      body: Container(
        color: Colors.redAccent[200],
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red[100],
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black38,
                  tabs: const [
                    Tab(icon: Icon(Icons.store)),
                    Tab(icon: Icon(Icons.check_circle)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: TabBarView(
                  children: [
                    InnerTabView(), // ✅ Nested tabs handled properly
                    StoreConfirm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class InnerTabView extends StatelessWidget {
  const InnerTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              dividerColor:Colors.transparent,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(child: Text('Add Shop Details',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ))),
                Tab(child: Text('Add Product Details',style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ))),
              ],
            ),
          const Expanded(
            child: TabBarView(
              children: [
                StoreDetails(),
                ProductDetails(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// StoreDetails.dart
class StoreDetails extends StatefulWidget {
  const StoreDetails({super.key});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  int selectedIndex = 3;
  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final gstController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionHeader('1/3', 'Add Store Details', 'Setup your shop by entering your description'),
            const SizedBox(height: 20),
            const Text('Select Shop Category', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                buildCategoryTile(index: 0, label: 'Accessories', icon: Icons.favorite_border_rounded),
                buildCategoryTile(index: 1, label: 'Food & Drinks', icon: Icons.local_cafe_outlined),
                buildCategoryTile(index: 2, label: 'Fashion', icon: Icons.checkroom_outlined),
                buildCategoryTile(index: 3, label: 'Arts & Craft', icon: Icons.card_giftcard_outlined),
                buildCategoryTile(index: 4, label: 'Health & Beauty', icon: Icons.health_and_safety),
                buildCategoryTile(index: 5, label: 'Other categories', icon: Icons.grid_view_outlined),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Add shop description', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            const Text('Shop name', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
            buildField(label: 'Shop Name', icon: Icons.store, controller: shopNameController),
            const SizedBox(height: 10),
            const Text('Owner name', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
            buildField(label: 'Owner Name', icon: Icons.person, controller: ownerNameController),

            const SizedBox(height: 10),
            const Text('Phone Number', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
            buildField(label: 'Phone Number', icon: Icons.phone, controller: phoneController, keyboardType: TextInputType.phone),

            const SizedBox(height: 10),
            const Text('Email', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
            buildField(label: 'Email', icon: Icons.email, controller: emailController, keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 10),
            const Text('Address', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
            buildField(label: 'Address', icon: Icons.location_on, controller: addressController),

            const SizedBox(height: 10),
            const Text('Pincode', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
            buildField(label: 'Pincode', icon: Icons.pin_drop, controller: pincodeController, keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            const Text('GST Number', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
            buildField(label: 'GST Number', icon: Icons.price_change_outlined, controller: gstController),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed:(){},
                style:ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.redAccent[200]
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Add Store',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryTile({required int index, required String label, required IconData icon}) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 40, color: Colors.black87),
                  const SizedBox(height: 12),
                  Text(label, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: label,
          fillColor: Colors.grey[50],
          filled: true,
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

    );
  }

  Widget sectionHeader(String step, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(step, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }
}

// ProductDetails.dart
class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<File> _images = [];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _images.add(File(picked.path)));
    }
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      print("Product Data Submitted");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      _nameController.clear();
      _descController.clear();
      _priceController.clear();
      _categoryController.clear();
      setState(() => _images.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionHeader('2/3', 'Add Product Details', 'Enter your product details here'),
            const SizedBox(height: 16),
            const Text('Product Images', style: TextStyle(fontSize: 20)),
            const Text('Add upto 5 images. First image is your products cover image that will be highlighted everywhere ', style: TextStyle(fontSize: 15,color:Colors.grey)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _images.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index < _images.length) {
                  return Stack(
                    children: [
                      Image.file(_images[index], fit: BoxFit.cover),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _images.removeAt(index)),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: Icon(Icons.add_a_photo, size: 30, color: Colors.red)),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            const Text('Enter Product Details', style: TextStyle(fontSize: 20)),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('Product Name', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
                  buildField(label: 'Product Name', icon: Icons.shopping_basket_rounded, controller: _nameController, keyboardType: TextInputType.none),
                  const SizedBox(height: 10),
                  const Text('Description', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
                  buildField(label: 'Description', icon: Icons.description, controller: _descController, keyboardType: TextInputType.none),
                  const SizedBox(height: 10),
                  const Text('Price', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
                  buildField(label: 'Price', icon: Icons.discount, controller: _priceController, keyboardType: TextInputType.none),
                  const SizedBox(height: 10),
                  const Text('Category', style: TextStyle(fontSize:15,fontWeight:FontWeight.bold,color: Colors.grey)),
                  buildField(label: 'Category', icon: Icons.category, controller: _categoryController, keyboardType: TextInputType.none),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitProduct,
                      style:ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.redAccent[200]
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Add Product',style: TextStyle(
                          color:Colors.white
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: label,
          fillColor: Colors.grey[50],
          filled: true,
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

    );
  }
  Widget sectionHeader(String step, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(step, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }
}

// StoreConfirm.dart
class StoreConfirm extends StatelessWidget {
  const StoreConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 50),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height:300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Shopadded.png'),
                  fit: BoxFit.cover, // You can change this as needed
                ),
              ),
            ),
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text("Store Setup Complete!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("You're all set to start adding and managing your products."),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text("Go to Dashboard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
