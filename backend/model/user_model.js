  const mongoose = require('mongoose');
  const { Schema, model } = mongoose;

  // Product Sub-Schema (Nested inside Shop)
  const productSchema = new Schema({
    productname: { type: String, required: true },
    category: { type: String },
    price: { type: Number },  // Change to Number
    description: { type: String },
    stock: { type: Number, required: true }, // Change to Number
    imagelink: { type: String },
    isAvailable: { type: Boolean, default: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
  });
  
  // Order Item Sub-Schema (Nested inside Orders)
  const orderItemSchema = new Schema({
    productId: { type: Schema.Types.ObjectId, ref: 'Products', required: true },
    quantity: { type: Number, required: true },
    price: { type: Number, required: true }
  });

  // Order Sub-Schema (Nested inside Shop)
  const orderSchema = new Schema({
    customerId: { type: Schema.Types.ObjectId, ref: 'Users', required: true },
    orderType: { type: String, enum: ['Onstore', 'Offstore'], required: true },
    items: [orderItemSchema], // Array of order items
    tableNumber: { type: Number }, // For Onstore orders (optional)
    status: { type: String, enum: ['Pending', 'Processing', 'Completed', 'Cancelled'], default: 'Pending' },
    totalAmount: { type: Number, required: true },
    paymentStatus: { type: String, enum: ['Pending', 'Paid'], default: 'Pending' },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
  });

  // Shop Schema (With Nested Products and Orders)
  const shopSchema = new Schema({
    ownerId: { type: Schema.Types.ObjectId, ref: 'Users', required: true },
    shopName: { type: String, required: true },
    ownername: { type: String, required: true },
    category: { type: String, required: true },
    contactInfo: {
      primaryPhone: { type: String, required: true },
      phone: { type: String },
      email: { type: String }
    },
    
    services: [{ type: String }], // Example: ['Onstore', 'Offstore']
    timings: {
      openingTime: { type: String },
      closingTime: { type: String }
    },
    location: {
      address: { type: String },
      city: { type: String },
      state: { type: String },
      pincode: { type: String },
      coordinates: {
        latitude: { type: Number },
        longitude: { type: Number }
      }
    },
    products: [productSchema], // Nested Products
    orders: [orderSchema], // Nested Orders
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
  });

  const tempDataSchema = new Schema({
    tempLocation: { type: String },
    tempLanguage: { type: String, default: 'en' },
    createdAt: { type: Date, default: Date.now, expires: '1d' } // Auto-delete after 1 day
});

const userSchema = new Schema({
    name: { type: String, required: true },
    phone: { type: String },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { type: String, enum: ['admin', 'manager', 'customer'], default: 'customer' },
    tempData: tempDataSchema, // Not an array
    shops: [shopSchema],
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});


  // Creating Models
  const User = model('vilmart_users', userSchema);

  // Exporting Models
  module.exports = { User };
