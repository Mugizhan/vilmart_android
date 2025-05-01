const nodemailer = require('nodemailer')
const sendMail = async (name, content,email, otp) => {
    try {
        const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: "bloodsharehub@gmail.com",
        pass: "lgry qxfl qpef ebut",
      }
    })
        const mailOptions = {
            from: 'www.sriramram173@gmail.com',
            to: email,
            subject: "hi",
            html: '<p>Hi ' + name + ',This is from BloodShare Hub.<br> It is your OTP : ' + otp + '</p>'
        }
        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.log(error);
            }
            else {
                console.log('Email has been send ', info.response);
            }
        })
    } catch (error) {
        console.log(error);
    }
}