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
    publishTextPromise.then((() => "")).catch((erro) => erro.toString());
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
            .then((querySnapshot) => {
                querySnapshot.forEach((doc) => {
                    var result = '';

                    if (doc.data().email === "") { //
                        result = " E-mail Not Sended ";
                    } else {
                        result = sendEmail(
                            NAME,
                            EMAIL,
                            doc.data().email,
                            "Aviso sobre cancelamento de consulta marcada na Clinica Odontologica Bambi",
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
                               <p>Informamos que foi cancelada, por motivos cívicos, sua consulta de hoje na Cl&iacute;nica Odontol&oacute;gica Bambi.</p>
                               <p>Acompanhe nossas redes sociais para mais notícias.</p>
                            </div>
                            
                            <link href="https://fonts.googleapis.com/css?family=Quicksand&display=swap" rel="stylesheet">
                            <style>
                                body {
                                    display: flex;
                                    margin: 0;
                                    align-items: center;
                                    justify-content: center;
                                    height: 100vh;
                                    background-color: #4c96b8;
                                }
                            
                                .presentational-container {
                                    background-color: #fff;
                                }
                            
                                table {
                                    background: none;
                                    margin: 0;
                                    padding: 10px 10px 0;
                                    border-width: 3px 0 0 0;
                                    border-style: solid;
                                    border-color: #4c96b8;
                                }
                            
                                tr.outer-row td.headshot-cell {
                                    padding: 0 12px 0 0;
                                }
                            
                                td.headshot-cell a {
                                    text-decoration: none;
                                }
                            
                                td.headshot-cell img {
                                    vertical-align: middle;
                                    width: 250px;
                                }
                            
                                td.description-cell {
                                    padding: 0 0 0 12px;
                                }
                            
                                td.description-cell>table {
                                    background: none;
                                    border: 0px;
                                    margin: 0;
                                    padding: 0;
                                }
                            
                                td.full-name {
                                    font-weight: bold;
                                    color: #4c96b8;
                                    font-size: 22px;
                                    font-family: 'Quicksand', sans-serif;
                                    font-weight: 600;
                                }
                            
                                td.title {
                                    padding-bottom: 10px;
                                    color: #555555;
                                    font-size: 14px;
                                    font-family: 'Quicksand', sans-serif;
                                    font-weight: 600;
                                }
                            
                                a.website {
                                    color: #4c96b8;
                                    text-decoration: none;
                                    font-weight: 600;
                                    font-size: 14px;
                                }
                            
                                td.social-icons {
                                    padding-top: 5px;
                                }
                            
                                td.social-icons ul {
                                    list-style: none;
                                    padding: 0;
                                    margin: 0;
                                    height: 25px;
                                }
                            
                                td.social-icons li {
                                    display: inline-block;
                                }
                            
                                td.social-icons a {
                                    text-decoration: none;
                                }
                            
                                td.social-icons img {
                                    width: 30px;
                                    height: 25px;
                                }
                            </style>
                            <div class="presentational-container">
                                <table role="presentation">
                                    <tbody>
                                        <tr class="outer-row">
                                            <td class="headshot-cell">
                                                <a href="https://clinicabambi.com.br">
                                                    <img src="https://firebasestorage.googleapis.com/v0/b/bambi-210400.appspot.com/o/logo_w250.png?alt=media&token=9e1801f0-69e3-4e1d-b310-62c248402f7d"
                                                        name="preview-image-url" alt="" />
                                                </a>
                                            </td>
                                            <td class="description-cell">
                                                <table role="presentation">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2" class="full-name">Cl&iacute;nica Odontol&oacute;gica Bambi</td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="title">
                                                                (21) 3350-1883 / (21) 3251-4180 / (21) 98037-4396<br>
                                                                clinicaodontologicabambi@gmail.com</td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="title">Condom&iacute;nio do Edif&iacute;cio P&oacute;lo I <br> Estr. do Portela, 99 -
                                                                715 - Madureira <br> Rio de Janeiro - RJ, 21351-050</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="title">
                                                                Agende sua consulta on-line:
                                                                <a class="website" href="https://clinicabambi.com.br">www.clinicabambi.com.br</a>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            `);
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
            .catch(((error) => console.log("Error getting documents: ", error)));
    });

/*

exports.scheduledFunctionRemember = functions.pubsub.schedule('0 8 * * *')
    .timeZone('America/Sao_Paulo') // Users can choose timezone - default is America/Los_Angeles
    .onRun((context) => {
        var db = admin.firestore();

        return db.collection(PATIENT_ACCOUNT_COLLECTION)//.where(
            //APPOINTMENT_SCHEDULING_DATE_APPOINTMENT_SCHEDULING_FIELD, "==",
            //new Date().toJSON().slice(0, 10).replace(/-/g, '-'))
            .get()
            .then((querySnapshot) => {
                var result = '';

                result = sendEmail(
                    NAME,
                    EMAIL,
                    "edrick_42@outlook.com",//doc.data().email,
                    "Lembrete sobre consulta marcada na Clinica Odontologica Bambi" + querySnapshot.size.toString(),
                    querySnapshot.size.toString());

                return console.log("End");
            })
            .catch(((error) => console.log("Error getting documents: ", error)));
    });

*/