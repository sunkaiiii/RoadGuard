import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use a service account
cred = credentials.Certificate('/home/pi/Documents/FIT5140_Assignment3/Python/MyMovieMemior-dd6c96eac3c0.json')
firebase_admin.initialize_app(cred)

db = firestore.client()


# doc_ref = db.collection(u'users').document(u'alovelace')
# doc_ref.set({
#     u'first': u'Ada',
#     u'last': u'Lovelace',
#     u'born': 1815
# })

# doc_ref = db.collection(u'users').document(u'aturing')
# doc_ref.set({
#     u'first': u'Alan',
#     u'middle': u'Mathison',
#     u'last': u'Turing',
#     u'born': 1912
# })

# users_ref = db.collection(u'users')
# docs = users_ref.stream()

# for doc in docs:
#     print(f'{doc.id} => {doc.to_dict()}')
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

