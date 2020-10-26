from pymongo import MongoClient
import datetime


post = {"author": "Mike","text": "My first blog post!","tags": ["mongodb", "python", "pymongo"],"date": datetime.datetime.utcnow()}
print(type(post))

# id = collection.insert_one(post).inserted_id

# print(id)

class MongodbSaver:

    def __init__(self, database_name,collection_name):
        self.database_name = database_name
        self.collection_name = collection_name
    def save_to_mongodb(self,data):
        client = MongoClient()
        db = client[self.database_name]
        collection = db[self.collection_name]
        id = collection.insert_one(data).inserted_id
        return collection.find_one({"_id":id})