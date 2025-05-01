const User = require('../model/user_model');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const MY_SECRET_KEY = 'your_secret_key_here'; 
const nodemailer = require('nodemailer');
const crypto = require('crypto');

let otpStore = {}; // In-memory store for OTPs, replace with a database in production

const generateOtp = () => {
  return crypto.randomInt(100000, 999999).toString();
};

const sendOtpEmail = async (email, otp) => {
  let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'vilmart2025@gmail.com',
      pass: 'atlc wdmy wsvl gozs'
    }
  });

  let mailOptions = {
    from: 'vilmart2025@gmail.com',
    to: email,
    subject: 'Your OTP Code',
    html: '<p>Hi This is from வில்mart<br> It is your OTP : ' + otp + '</p>'
  };

  await transporter.sendMail(mailOptions);
};



const createotp = async (req, res, next) => {
  const { email } = req.body;
  const otp = generateOtp();
  otpStore[email] = otp;
  console.log(`Generated OTP for ${email}: ${otp}`);

  try {
    await sendOtpEmail(email, otp);
    res.status(200).send({ message: "OTP sent successfully" });
  } catch (error) {
    console.error('Error sending OTP email:', error);
    res.status(500).send({ message: "Failed to send OTP" });
  }
};

const verifyOtp = (req, res, next) => {
  const { email, otp } = req.body;
  if (otpStore[email] === otp) {
    delete otpStore[email]; // Remove OTP after successful verification
    res.status(200).send({ message: "OTP verified successfully" });
  } else {
    res.status(400).send({ message: "Invalid OTP" });
  }
};

const login = async (req, res, next) => {
  const { username, password, shopcode } = req.body;
  let isUser;

  try {
    isUser = await User.findOne({ shopcode: shopcode });
    console.log(isUser)
  } catch (err) {
    return res.status(500).json({ message: "Server Error" });
  }

  if (!isUser) {
    return res.status(400).json({ message: "Shop Not Found" });
  }

  
  if (username === isUser.username) {
    const isPassword = bcryptjs.compareSync(password, isUser.password);
    if (!isPassword) {
      return res.status(400).json({ message: "Invalid Password! Try again" });
    }

    const token = jwt.sign({ id: isUser._id }, MY_SECRET_KEY, { expiresIn: '1h' });

    res.status(200).cookie(String(isUser._id), token, {
      path: '/',
      expires: new Date(Date.now() + 60 * 60 * 1000),
      httpOnly: true,
      sameSite: "lax",
    });

    return res.status(200).json({ user: isUser, token, usertype: 'Admin' });
  }

  // Check if the username matches any chiefname
  const chief = isUser.chief.find(chief => chief.chiefname === username);
  if (chief) {
    const isPassword = bcryptjs.compareSync(password, chief.chiefpassword);
    if (!isPassword) {
      return res.status(400).json({ message: "Invalid Password! Try again" });
    }

    const token = jwt.sign({ id: isUser._id }, MY_SECRET_KEY, { expiresIn: '1h' });

    res.status(200).cookie(String(isUser._id), token, {
      path: '/',
      expires: new Date(Date.now() + 60 * 60 * 1000),
      httpOnly: true,
      sameSite: "lax",
    });

    return res.status(200).json({ user: isUser, token, usertype: 'Chief' });
  }

  return res.status(400).json({ message: "Invalid Username! Try again" });
};

const verifyToken = (req, res, next) => {
    const cookie = req.headers.cookie;
    const istoken = cookie ? cookie.split("=")[1] : null;
  
    if (!istoken) {
      return res.status(404).json({ message: "No token found" });
    }
  
    jwt.verify(String(istoken), MY_SECRET_KEY, (err, user) => {
      if (err) {
        return res.status(400).json({ message: "Invalid token" });
      }
      req.id = user.id;
      next();
    });
  };
  
  const getUser = async (req, res, next) => {
    const userId = req.id;
    let user;
  
    try {
      user = await User.findById(userId, "-password");
    } catch (err) {
      return res.status(500).json({ message: "Server Error" });
    }
  
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
  
    return res.status(200).json(user);
  };
  
const chiefEntry = async (req, res, next) => {
  const { chiefname, chiefpassword } = req.body;
  const id = req.params.id;

  if (!chiefname || !chiefpassword) {
    return res.status(400).json({ message: "Chief name and password are required" });
  }

  try {
    const hashpassword = bcryptjs.hashSync(chiefpassword, 10);
    await User.findByIdAndUpdate(id, {
      $push: {
        chief: {
          chiefname: chiefname,
          chiefpassword: hashpassword,
        },
      },
    });

    res.status(200).json({ message: "Chief added successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "An error occurred while adding the Chief" });
  }
};

const foodEntry = async (req, res, next) => {
  const { foodname, foodprice, foodcategory, foodimage } = req.body;
  const id = req.params.id;

  try {
    await User.findByIdAndUpdate(id, {
      $push: {
        food: {
          foodname,
          foodprice,
          foodcategory,
          foodimage,
        },
      },
    });

    res.status(200).json({ message: "Food entry added successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "An error occurred while adding the food entry" });
  }
};

const foodEdit = async (req, res, next) => {
  const { foodname, foodprice, foodcategory, foodimage, index, foodstatus } = req.body;
  const id = req.params.id;

  try {
    const update = {
      [`food.${index}`]: {
        foodname,
        foodprice,
        foodcategory,
        foodimage,
        foodstatus,
      },
    };

    await User.findByIdAndUpdate(id, { $set: update });

    res.status(200).json({ message: "Food entry updated successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "An error occurred while updating the food entry" });
  }
};

const foodDelete = async (req, res) => {
  const id = req.params.id;
  const { index } = req.body;

  try {
    const update = {
      $unset: { [`food.${index}`]: 1 },
      $pull: { food: null },
    };

    await User.findByIdAndUpdate(id, update);

    res.status(200).json({ message: "Food entry deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "An error occurred while deleting the food entry" });
  }
};

const foodFetch = async (req, res, next) => {
  const code = req.params.id;

  try {
    const user = await User.findById(code);

    if (user) {
      res.status(200).json({ food: user.food, shopname: user.shopname });
    } else {
      res.status(404).json({ message: "Shop not found" });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const Orders = async (req, res, next) => {
  const { id } = req.params;
  const { orderItems, table } = req.body;

  try {
    const update = {
      $push: {
        orders: {
          table,
          orderItems,
        },
      },
    };

    const result = await User.findByIdAndUpdate(id, update);

    if (!result) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({ message: "Order entry updated successfully", updatedUser: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "An error occurred while updating the order entry" });
  }
};

const orderDelete = async (req, res, next) => {
  const id = req.params.id;
  const { orderIndex } = req.body;

  try {
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (user.orders && user.orders.length > orderIndex) {
      user.orders.splice(orderIndex, 1);
      await user.save();
      res.status(200).json({ message: "Order deleted successfully" });
    } else {
      res.status(400).json({ message: "Invalid order index" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "An error occurred while deleting the order" });
  }
};

module.exports = {
  login,
  verifyToken,
  getUser,
  chiefEntry,
  foodEntry,
  foodEdit,
  foodDelete,
  foodFetch,
  Orders,
  orderDelete,
  createotp,
  verifyOtp
};