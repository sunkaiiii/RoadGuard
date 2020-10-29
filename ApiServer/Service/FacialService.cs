using ApiServer.Model;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiServer.Service
{
    public class FacialService
    {
        private readonly IMongoCollection<FacialInformation> collection;

        public FacialService(IFIT5140DatabaseSettings settings)
        {
            var client = new MongoClient(settings.ConnectionString);
            var database = client.GetDatabase(settings.DatabaseName);
            collection = database.GetCollection<FacialInformation>(settings.FacialCollectionName);
        }

        public List<FacialInformation> Get() => collection.Find(face => true).ToList();
    }
}
