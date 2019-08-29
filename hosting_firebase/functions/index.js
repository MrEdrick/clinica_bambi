const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const cors = require('cors')({ origin: true });
const axios = require('axios');

const NAME = 'Clinica Bambi';
const EMAIL = 'clinicaodontologicabambi@gmail.com';
const PASSWORD = 'B715706**';
const AMAZON_API_ENDPONT_SEND_EMAIL = 'https://mz8uki4o3l.execute-api.us-east-1.amazonaws.com/default/sendEmail';
const GMAIL_API_ENDPONT_SEND_EMAIL = 'https://us-central1-bambi-210400.cloudfunctions.net/sendMail';


admin.initializeApp();

/**
* Here we're using Gmail to send 
*/
let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: EMAIL,
        pass: PASSWORD
    }
});

exports.sendMail = functions.https.onRequest((req, res) => {
    cors(req, res, () => {

        // getting dest email by query string
        const dest = req.query.dest;
        const subject = req.query.subject;
        const html = JSON.parse(req.body).message;

        const mailOptions = {
            from: NAME + ' <' + EMAIL + '>',
            to: dest,
            subject: subject, // email subject
            html: html// email content in HTML
        };

        // returning result
        return transporter.sendMail(mailOptions, (erro, info) => {
            if (erro) {
                return res.send(erro.toString());
            }
            return res.send('Sended');
        });
    });
});

exports.scheduledFunctionRemember = functions.pubsub.schedule('every day 08:00')
    .timeZone('America/Sao_Paulo') // Users can choose timezone - default is America/Los_Angeles
    .onRun((context) => {
        axios({
            method: 'post',
            url: '/user/12345',
            data: {
                firstName: 'Fred',
                lastName: 'Flintstone'
            }
        });
        console.log('This will be run every day at 11:05 AM Eastern!');
    });