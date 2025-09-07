import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final double amount;

  const PaymentPage({Key? key, required this.amount}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPayment = 'RazorPay';
  bool _isProcessing = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Release resources
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful")),
    );
    setState(() {
      _isProcessing = false;
    });
    Navigator.of(context).pop(true); // <- Only here
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void _processPayment() {
    var options = {
      'key': 'rzp_test_sUwc8iQu4wUciz', // Replace with your actual Razorpay Key
      'amount': ((widget.amount + (widget.amount / 100)) * 100).toInt(), // in paise
      'name': 'Vilmart',
      'description': 'Order Payment',
      'prefill': {
        'contact': '9384932109',
        'email': 'pnmuugizhan@gmail.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      setState(() {
        _isProcessing = true;
      });
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        _isProcessing = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment',style: TextStyle(
          color:Colors.black
        )),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.search,color: Colors.black,),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isProcessing
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Processing payment...'),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

             const Text('Order summary',style: TextStyle(
               fontWeight: FontWeight.bold,
               fontSize: 20
             ),),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order',style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),),
                      Text('₹${widget.amount.toStringAsFixed(2)}',style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),),

                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Taxes',style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),),
                      Text('₹${(widget.amount/100).toStringAsFixed(2)}',style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),),

                    ],
                  ),
                  const SizedBox(height:15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:const [
                       Text('Delivery fees',style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),),
                      Text('₹${0.00}',style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),),

                    ],
                  ),
                  const SizedBox(height:25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 17
                      ),),
                      Text('₹${(widget.amount+(widget.amount/100)).toStringAsFixed(2)}',style:const TextStyle(
                        fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 17
                      ),),

                    ],
                  ),
                  const SizedBox(height:15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:const [
                      Text('Estimated delivery time',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12
                      ),),
                      Text('5-10mins in & around 5km',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12
                      ),),

                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height:20),

            // Payment Method
            const Text("Payment Method",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Card(
                  elevation: 3,
                  color: Color(0xFF012652),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/images/razorpay.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: const Text('Razor Pay', style: TextStyle(color: Colors.white)),
                    trailing: Radio<String>(
                      value: 'RazorPay',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                      fillColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    subtitle: const Text('Select this payment method', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Card(
                  elevation: 3,

                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 40,
                      decoration:const BoxDecoration(
                        image:DecorationImage(
                          image: AssetImage('assets/images/googlepay.png')
                        )
                      ),
                    ),
                    title: const Text('Google Pay'),
                    trailing: Radio<String>(
                      value: 'Google Pay',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                    ),
                    subtitle: const Text('Currently service Not available', style: TextStyle(color: Colors.red)),
                  ),
                ),


                Card(
                  elevation: 3,
                  color: Colors.deepPurple,
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/Phonepe.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: const Text('PhonePe', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Currently service Not available', style: TextStyle(color: Colors.red)),
                    trailing: Radio<String>(
                      value: 'PhonePe',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                      fillColor: MaterialStatePropertyAll(Colors.white),
                    ),
                  ),
                ),

                Card(
                  elevation: 3,
                  color: Colors.blue ,
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/images/paytm.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: const Text(
                      'Paytm',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text('Currently service Not available', style: TextStyle(color: Colors.red)),
                    trailing: Radio<String>(
                      value: 'Paytm',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                      fillColor: MaterialStatePropertyAll(Colors.white),
                    ),
                  ),
                ),

                           ],
            ),


            const Spacer(),

            // Confirm Payment Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  children: [
                    const Text('Total price',
                        style:TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Colors.grey)),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('₹',
                            style:TextStyle(fontSize: 25,fontWeight: FontWeight.normal,color: Colors.red)),
                        SizedBox(width: 10),
                        Text('${widget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Pay Now',
                      style:  TextStyle(fontSize: 16)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
