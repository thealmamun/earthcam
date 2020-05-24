const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = "XZYQ55MJCW";
const ALGOLIA_ADMIN_KEY = "f7b8dad4745b86eb0b0e403d4d4f8606";
const ALGOLIA_INDEX_NAME = "cams";

admin.initializeApp(functions.config().firebase);

exports.addFirestoreDataToAlgolia = functions.https.onRequest(async (req, res) => {

    var arr = [];

    admin.firestore().collection("cams").get().then((docs) => {
            docs.forEach((doc) => {
                let user = doc.data();
                user.objectID = doc.id;
                arr.push(user);
            })
            var client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
            var index = client.initIndex(ALGOLIA_INDEX_NAME);

            index.saveObjects(arr, function(err,content){
                res.status(200).send(content);
            })
    })
})