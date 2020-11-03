from firebase import FireStoreSaver
import json

firestore = FireStoreSaver("facial")
query = firestore.getAllData().stream()
for doc in query:
    print(f'{doc.id} => {doc.to_dict()}')