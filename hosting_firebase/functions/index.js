//const firebase = require('firebase');
const admin = require('firebase-admin');
const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const cors = require('cors')({ origin: true });

const NAME = 'Clinica Bambi';
const EMAIL = 'clinicaodontologicabambi@gmail.com';
const PASSWORD = 'B715706**';
//const AMAZON_API_ENDPONT_SEND_EMAIL = 'https://mz8uki4o3l.execute-api.us-east-1.amazonaws.com/default/sendEmail';
//const GMAIL_API_ENDPONT_SEND_EMAIL = 'https://us-central1-bambi-210400.cloudfunctions.net/sendMail';
const APPOINTMENT_SCHEDULING_COLLECTION = 'appointmentsScheduling';
const APPOINTMENT_SCHEDULING_DATE_APPOINTMENT_SCHEDULING_FIELD = 'dateAppointmentScheduling';

admin.initializeApp();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: EMAIL,
        pass: PASSWORD
    }
});

const firebaseConfig = {
    apiKey: "AIzaSyATOL9trCxr-LOmQDsvhgnLl36YZ61IQn4",
    authDomain: "bambi-210400.firebaseapp.com",
    databaseURL: "https://bambi-210400.firebaseio.com",
    projectId: "bambi-210400",
    storageBucket: "bambi-210400.appspot.com",
    messagingSenderId: "1046590420458",
    appId: "1:1046590420458:web:03d67dfa9cab2693"
};

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
            return res.send(erro.toString());
        }
        return res.send('Sended');
    });
}

exports.sendMail = functions.https.onRequest((req, res) => {
    cors(req, res, () => {

        // getting dest email by query string
        const dest = req.query.dest;
        const subject = req.query.subject;
        const html = JSON.parse(req.body).message;

        // returning result
        return sendEmail(NAME, EMAIL, dest, subject, html);
    });
});

exports.scheduledFunctionRemember = functions.pubsub.schedule('0 8 * * *')
    .timeZone('America/Sao_Paulo') // Users can choose timezone - default is America/Los_Angeles
    .onRun((context) => {
        var db = admin.firestore();

        db.collection(APPOINTMENT_SCHEDULING_COLLECTION).where(
            APPOINTMENT_SCHEDULING_DATE_APPOINTMENT_SCHEDULING_FIELD, "==",
            new Date().toJSON().slice(0, 10).replace(/-/g, '-'))
            .get()
            .then(function (querySnapshot) {
                querySnapshot.forEach(function (doc) {
                    return sendEmail(NAME, EMAIL, 'edrickmanoel@nasajon.com.br', 'Lembre de consulta marcada', 'Olá ' + doc.data().patient);
                });
                return console.log("Sended");
            })
            .catch(function (error) {
                return console.log("Error getting documents: ", error);
            });
    });