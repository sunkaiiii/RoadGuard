using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiServer.Model
{
    public class FIT5140DatabaseSettings: IFIT5140DatabaseSettings
    {
        public string FacialCollectionName { get; set; }
        public string ConnectionString { get; set; }
        public string DatabaseName { get; set; }
    }

    public interface IFIT5140DatabaseSettings
    {
        string FacialCollectionName { get; set; }
        string ConnectionString { get; set; }
        string DatabaseName { get; set; }
    }
}
