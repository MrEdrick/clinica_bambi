const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const cors = require('cors')({origin: true});

const name = 'Clinica Bambi';
const email = 'clinicaodontologicabambi@gmail.com';
const password = 'B706715**';

admin.initializeApp();

/**
* Here we're using Gmail to send 
*/
let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: email,
        pass: password
    }
});

exports.sendMail = functions.https.onRequest((req, res) => {
    cors(req, res, () => {
      
        // getting dest email by query string
        const dest = req.query.dest;

        const mailOptions = {
            from: name + ' <' + email + '>',
            to: dest,
            subject: 'I\'M A PICKLE!!!', // email subject
            html: `<p style="font-size: 16px;">Pickle Riiiiiiiiiiiiiiiick!!</p>
                <br />
                <img src="https://images.prod.meredith.com/product/fc8754735c8a9b4aebb786278e7265a5/1538025388228/l/rick-and-morty-pickle-rick-sticker" />
            ` // email content in HTML
        };
  
        // returning result
        return transporter.sendMail(mailOptions, (erro, info) => {
            if(erro){
                return res.send(erro.toString());
            }
            return res.send('Sended');
        });
    });    
});