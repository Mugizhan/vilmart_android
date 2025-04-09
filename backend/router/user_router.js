const express = require('express');
const { signup, login, verifyToken, getUser, shopData, logOut, getProduct,getTemp} = require('../controller/user_controller');
const router = express.Router();

router.post('/signup', signup);
router.post('/login', login);
router.get('/getUser', verifyToken, getUser);
router.put('/shopData/:id', shopData); 
router.get('/logout', logOut); 
router.get('/products', getProduct);
router.put('/setTemp/:userId', getTemp);

module.exports = router;