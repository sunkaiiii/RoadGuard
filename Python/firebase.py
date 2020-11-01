import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use a service account
cred = credentials.Certificate('/home/pi/Documents/FIT5140_Assignment3/Python/serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()
class FireStoreSaver:
    def __init__(self,collection_name):
        self.collection_name = collection_name
    def save_to_firestore(self,data):
        self._save_data(self.collection_name,data)
    def _save_data(self,collection_name, document, document_name=None):
        if document_name is None:
            doc_ref = db.collection(collection_name).document()
        else:
            doc_ref = db.collection(collection_name).document(document_name)
        doc_ref.set(document)

