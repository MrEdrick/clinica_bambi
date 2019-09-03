//const firebase = require('firebase');
const admin = require('firebase-admin');
const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const cors = require('cors')({ origin: true });
const AWS = require('aws-sdk');

const NAME = 'Clinica Bambi';
const EMAIL = 'clinicaodontologicabambi@gmail.com';
const PASSWORD = 'B715706**';
//const AMAZON_API_ENDPONT_SEND_EMAIL = 'https://mz8uki4o3l.execute-api.us-east-1.amazonaws.com/default/sendEmail';
//const GMAIL_API_ENDPONT_SEND_EMAIL = 'https://us-central1-bambi-210400.cloudfunctions.net/sendMail';
const APPOINTMENT_SCHEDULING_COLLECTION = 'appointmentsScheduling';
const APPOINTMENT_SCHEDULING_DATE_APPOINTMENT_SCHEDULING_FIELD = 'dateAppointmentScheduling';

const firebaseConfig = {
    apiKey: "AIzaSyATOL9trCxr-LOmQDsvhgnLl36YZ61IQn4",
    authDomain: "bambi-210400.firebaseapp.com",
    databaseURL: "https://bambi-210400.firebaseio.com",
    projectId: "bambi-210400",
    storageBucket: "bambi-210400.appspot.com",
    messagingSenderId: "1046590420458",
    appId: "1:1046590420458:web:03d67dfa9cab2693"
};

const awsConfig = {
    accessKeyId: "AKIAQZ6GT4OEEFGM3HM5",
    secretAccessKey: "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",
    region: "us-west-2"
}

admin.initializeApp();
AWS.config.update(awsConfig);

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: EMAIL,
        pass: PASSWORD
    }
});

function sendSMS(phoneNumber) {
    var params = {
        Message: `Ola, tudo bem?
        Passando para lembrar da sua consulta hoje na Clinica Odontologica Bambi. 
        Sera um prazer recebe-lo!`, 
        PhoneNumber: phoneNumber, 
    };

    var publishTextPromise = new AWS.SNS({ apiVersion: '2010-03-31' }).publish(params).promise();
    publishTextPromise.then(
        function (data) {
            return "";
        }).catch(
            function (erro) {
                return erro.toString();
            });
}

function sendEmail(name, email, to, subject, html) {
    const mailOptions = {
        from: email + ' <' + name + '>',
        to: to,
        subject: subject, // email subject
        html: html// email content in HTML
    };

    // returning result
    return transporter.sendMail(mailOptions, (erro, info) => {
        if (erro) {
            return erro.toString();
        }
        return '';
    });
}

exports.sendMail = functions.https.onRequest((req, res) => {
    cors(req, res, () => {

        // getting dest email by query string
        const dest = req.query.dest;
        const subject = req.query.subject;
        const html = JSON.parse(req.body).message;

        // returning result
        return res.send(sendEmail(NAME, EMAIL, dest, subject, html));
    });
});

exports.scheduledFunctionRemember = functions.pubsub.schedule('0 8 * * *')
    .timeZone('America/Sao_Paulo') // Users can choose timezone - default is America/Los_Angeles
    .onRun((context) => {
        var db = admin.firestore();

        return db.collection(APPOINTMENT_SCHEDULING_COLLECTION).where(
            APPOINTMENT_SCHEDULING_DATE_APPOINTMENT_SCHEDULING_FIELD, "==",
            new Date().toJSON().slice(0, 10).replace(/-/g, '-'))
            .get()
            .then(function (querySnapshot) {
                querySnapshot.forEach(function (doc) {
                    var result = '';

                    if (doc.data().email === "") { //
                        result = " E-mail Not Sended ";
                    } else {
                        result = sendEmail(
                            NAME,
                            EMAIL,
                            doc.data().email,
                            'Lembre sobre consulta marcada na Cl&iacute;nica Odontol&oacute;gica Bambi',
                            `<div 
                                style=" font-family:Arial, Helvetica, sans-serif; 
                                font-size: 22px; 
                                font-weight: 600;
                                color:#666666;">
                               Ol&aacute;, tudo bem?
                            </div>
                            <div 
                                style=" font-family:Arial, Helvetica, sans-serif; 
                                font-size: 16px; 
                                font-weight: 600;
                                color:#888888;">
                               <p>Passando para lembrar da sua consulta hoje na Cl&iacute;nica Odontol&oacute;gica Bambi.</p>
                               <p>Ser&aacute; um prazer receb&ecirc;-lo!</p>
                            </div>`);
                    }

                    if ((doc.data().tel.replace(/\D/g, "") === '') || (doc.data().tel.replace(/\D/g, "").length === 11)) {
                        result = result + " SMS Not Sended ";
                    } else {
                        result = result + " SMS Not Sended ";//result = sendSMS("+55" + doc.data().tel.replace(/\D/g, ""));
                    }

                    return result;
                });

                return console.log("End");
            })
            .catch(function (error) {
                return console.log("Error getting documents: ", error);
            });
    });