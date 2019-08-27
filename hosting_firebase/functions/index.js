const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const cors = require('cors')({origin: true});

const name = 'Clinica Bambi';
const email = 'clinicaodontologicabambi@gmail.com';
const password = 'B715706**';

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
        const subject = req.query.subject;
        const html = JSON.parse(req.body).message;

        const mailOptions = {
            from: name + ' <' + email + '>',
            to: dest,
            subject: subject, // email subject
            html: html// email content in HTML
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

/*exports.scheduledFunctionRemember = functions.pubsub.schedule('5 11 * * *')
  .timeZone('America/New_York') // Users can choose timezone - default is America/Los_Angeles
  .onRun((context) => {
  console.log('This will be run every day at 11:05 AM Eastern!');
});*/