const { User } = require('../model/user_model');
const bcrypt = require("bcryptjs");
const jwt = require('jsonwebtoken');
const JWT_SECRET_KEY ="my_secret_key";

const signup = async (req, res) => {
  const { name,phone, email, password } = req.body;
  try {
     const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({ message: "Account already exists" });
    }

    const newUser = new User({
      name,
      phone,
      email,
      password,
    });

    await newUser.save();
    return res.status(201).json({ message: "Account created successfully" });
  } catch (err) {
    console.error("Error in signup:", err);
    return res.status(500).json({ message: "Server error. Please try again later." });
  }
};

const login = async (req, res) => {
  const { phone, password } = req.body;

  try {
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    if (password!= user.password) {
      return res.status(400).json({ message: "Invalid password" });
    }

    const token = jwt.sign({ id: user._id }, JWT_SECRET_KEY, { expiresIn: "24h" });
    
    res.cookie(String(user._id), token, {
      expires: new Date(Date.now() + 24 * 60 * 60 * 1000),
      httpOnly: true,
      secure: process.env.NODE_ENV === "production", // True in production, false in development
      sameSite: process.env.NODE_ENV === "production" ? "None" : "Lax", // Adjust for dev/prod
    });
    

    return res.status(201).json({ message: "Login successful" });
  } catch (err) {
    console.error("Error in login:", err);
    return res.status(500).json({ message: "Server error. Please try again later." });
  }
};

const verifyToken = (req, res, next) => {
  console.log("Verifying Token...");
  const token = req.cookies ? Object.values(req.cookies)[0] : null;
  console.log(token)

  if (!token) {
    return res.status(401).json({ message: "No token found" });
  }

  jwt.verify(token, JWT_SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ message: "Invalid token" });
    }
    req.id = user.id;
    next();
  });
};
  
  const getUser = async (req, res) => {
    const userId = req.id;
  
    try {
      const user = await User.findById(userId).select("-password");
      
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }
      return res.status(200).json(user);
    } catch (err) {
      console.error("Error fetching user:", err);
      return res.status(500).json({ message: "Server error", error: err.message });
    }
  };


  const shopData = async (req, res, next) => {
    const { shops, products } = req.body; // shops and products data from request body
    const userId = req.params.id; // Get the userId from the URL params
    console.log(req.body)
    // Validate that all required fields are available
    if (!shops || !products) {
      return res.status(400).json({ message: "Shops and products data are required" });
    }

const shopDetails = {
  shopName: shops?.shopName ?? '',
  ownername: shops?.ownername ?? '',
  category: shops?.category ?? '',
  contactInfo: {
    primaryPhone: shops?.primaryPhone ?? '', 
    phone: shops?.phone ?? '', 
    email: shops?.email ?? ''
  },
  services: shops?.services === 'both' ? ['Onstore', 'Offstore'] : [shops?.services] ?? [],
  timings: {
    openingTime: shops?.timing ?? '', 
    closingTime: shops?.closingTime ?? '' 
  },
  location: {
    address: decodeURIComponent(shops?.location?.address ?? ''),
    city: shops?.location?.city ?? '',
    state: shops?.location?.state ?? '',
    pincode: shops?.location?.pincode ?? '',
    coordinates: {
      latitude: shops?.coordinates?.latitude ?? 0,
      longitude: shops?.coordinates?.longitude ?? 0,
    },
  },

  products: products ?? [], 
};


    
  
    console.log("Received shop details:", shopDetails);
    console.log("User ID:", userId);
  
    try {
      // If you are adding the shop to the `shops` array, use $push.
      // If you're updating an existing shop, use $set for the specific index of the shop (if necessary).
      const updatedUser = await User.findByIdAndUpdate(
        { _id: userId },
        { $push: { shops: shopDetails } }, // Use $push to add new shop
        { new: true }  // Return the updated document
      );
  
      if (!updatedUser) {
        return res.status(404).json({ message: "User not found" });
      }
  
      // Send success response
      return res.status(200).json({ message: "Shop data updated successfully", updatedUser });
    } catch (err) {
      console.error("Error saving shop data:", err);
      return res.status(500).json({ message: "Server error", error: err.message });
    }
  };
  

  const getProduct = async (req, res, next) => {

    try {
      
      // const { city } = req.query;
      // const matchStage = city ? { "shops.location.city": city } : {};
      
      // const shops = await User.aggregate([
      //   { $unwind: "$shops" },
      //   { $match: matchStage },
      //   { $project: { 
      //       _id: 0, 
      //       id: "$_id",
      //       shopName: "$shops.shopName", 
      //       products: "$shops.products" 
      //   }}
      // ]);
      
      const shops = await User.aggregate([
        { $unwind: "$shops" },
        { $match: { "shops.location.city": "Sivakasi" } },
        { $project: { 
            _id: 0, 
            "id": "$_id",
            "shopName": "$shops.shopName", 
            "products": "$shops.products" 
        }}
      ]);
      res.status(200).json(shops);
    } catch (error) {
      res.status(500).json({ message: 'Server error' });
    }
  };
  
  const getTemp = async (req, res) => {
    try {
        const { userId } = req.params;
        const { tempLocation, tempLanguage } = req.body;
        console.log(userId)
        console.log(req.body)

        const updatedUser = await User.findByIdAndUpdate(
            userId,
            {
                tempData: { tempLocation, tempLanguage, createdAt: new Date() }
            },
            { new: true } // Return updated user
        );

        if (!updatedUser) {
            return res.status(404).json({ error: "User not found" });
        }

        res.json(updatedUser.tempData);
    } catch (error) {
        console.error("Error updating temp data:", error);
        res.status(500).json({ error: "Failed to update temp data" });
    }
};



  const logOut=(res,req,next)=>{
    console.log("logout")
    res.clearCookie('token',{
      httpOnly:true,
      secure:true,
      sameSite:strict
    })

    return res.status(200).json({
      message:"Logged out successfully"
    })
  }


  
  
  

module.exports = { signup, login, verifyToken, getUser,shopData,logOut,getProduct,getTemp};