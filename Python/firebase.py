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
        self.collection = db.collection(collection_name)
    def save_to_firestore(self,data):
        return self._save_data(self.collection_name,data)
    def _save_data(self,collection_name, document, document_name=None):
        if document_name is None:
            doc_ref = self.collection.document()
        else:
            doc_ref = self.collection.document(document_name)
        doc_ref.set(document)
        print("Successfully added document:", doc_ref.id)
        return doc_ref
    def queryById(self,id):
        query = self.collection.where(u'id',u'==',id)
        return query
    def getAllData(self):
        return self.collection


class FileStoreUserSelectedRoad:
    def __init__(self):
        self.collection = db.collection("selectedRoad")
    def queryByPlaceId(self, placeId):
        query = self.collection.where(u'PlaceIds',u'array_contains',placeId)
        return list(query.stream())

# https://stackoverflow.com/questions/56918460/how-to-fix-error-object-of-type-generator-has-no-len-python
if __name__=="__main__":
    firebase = FileStoreUserSelectedRoad()
    query = firebase.queryByPlaceId("ChIJyzwejcRq1moR4J7N3zYV5lo")
    for q in query:
        print(q.id)