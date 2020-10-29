using System;
using System.Collections.Generic;

using System.Globalization;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

[BsonIgnoreExtraElements]
public partial class FacialInformation
{
    [JsonProperty("_id")]
    [BsonId]
    [BsonRepresentation(BsonType.ObjectId)]
    public string Id { get; set; }

    [JsonProperty("FaceDetails")]
    public List<FaceDetail> FaceDetails { get; set; }

    [JsonProperty("ImageUrl")]
    public Uri ImageUrl { get; set; }
}

public partial class FaceDetail
{
    [JsonProperty("BoundingBox")]
    public BoundingBox BoundingBox { get; set; }

    [JsonProperty("AgeRange")]
    public AgeRange AgeRange { get; set; }

    [JsonProperty("Smile")]
    public Beard Smile { get; set; }

    [JsonProperty("Eyeglasses")]
    public Beard Eyeglasses { get; set; }

    [JsonProperty("Sunglasses")]
    public Beard Sunglasses { get; set; }

    [JsonProperty("Gender")]
    public Gender Gender { get; set; }

    [JsonProperty("Beard")]
    public Beard Beard { get; set; }

    [JsonProperty("Mustache")]
    public Beard Mustache { get; set; }

    [JsonProperty("EyesOpen")]
    public Beard EyesOpen { get; set; }

    [JsonProperty("MouthOpen")]
    public Beard MouthOpen { get; set; }

    [JsonProperty("Emotions")]
    public List<Emotion> Emotions { get; set; }

    [JsonProperty("Landmarks")]
    public List<Landmark> Landmarks { get; set; }

    [JsonProperty("Pose")]
    public Pose Pose { get; set; }

    [JsonProperty("Quality")]
    public Quality Quality { get; set; }

    [JsonProperty("Confidence")]
    public double Confidence { get; set; }
}

public partial class AgeRange
{
    [JsonProperty("Low")]
    public long Low { get; set; }

    [JsonProperty("High")]
    public long High { get; set; }
}

public partial class Beard
{
    [JsonProperty("Value")]
    public bool Value { get; set; }

    [JsonProperty("Confidence")]
    public double Confidence { get; set; }
}

public partial class BoundingBox
{
    [JsonProperty("Width")]
    public double Width { get; set; }

    [JsonProperty("Height")]
    public double Height { get; set; }

    [JsonProperty("Left")]
    public double Left { get; set; }

    [JsonProperty("Top")]
    public double Top { get; set; }
}

public partial class Emotion
{
    [JsonProperty("Type")]
    public string Type { get; set; }

    [JsonProperty("Confidence")]
    public double Confidence { get; set; }
}

public partial class Gender
{
    [JsonProperty("Value")]
    public string Value { get; set; }

    [JsonProperty("Confidence")]
    public double Confidence { get; set; }
}

public partial class Landmark
{
    [JsonProperty("Type")]
    public string Type { get; set; }

    [JsonProperty("X")]
    public double X { get; set; }

    [JsonProperty("Y")]
    public double Y { get; set; }
}

public partial class Pose
{
    [JsonProperty("Roll")]
    public double Roll { get; set; }

    [JsonProperty("Yaw")]
    public double Yaw { get; set; }

    [JsonProperty("Pitch")]
    public double Pitch { get; set; }
}

public partial class Quality
{
    [JsonProperty("Brightness")]
    public double Brightness { get; set; }

    [JsonProperty("Sharpness")]
    public double Sharpness { get; set; }
}
public partial class ResponseMetadata
{
    [JsonProperty("RequestId")]
    public Guid RequestId { get; set; }

    [JsonProperty("HTTPStatusCode")]
    public long HTTPStatusCode { get; set; }

    [JsonProperty("HTTPHeaders")]
    public HttpHeaders HttpHeaders { get; set; }

    [JsonProperty("RetryAttempts")]
    public long RetryAttempts { get; set; }
}

public partial class HttpHeaders
{
    [JsonProperty("content-type")]
    public string ContentType { get; set; }

    [JsonProperty("date")]
    public string Date { get; set; }

    [JsonProperty("x-amzn-requestid")]
    public Guid XAmznRequestid { get; set; }

    [JsonProperty("content-length")]
    [JsonConverter(typeof(ParseStringConverter))]
    public long ContentLength { get; set; }

    [JsonProperty("connection")]
    public string Connection { get; set; }
}

public partial class FacialInformation
{
    public static FacialInformation FromJson(string json) => JsonConvert.DeserializeObject<FacialInformation>(json, Converter.Settings);
}

public static class Serialize
{
    public static string ToJson(this FacialInformation self) => JsonConvert.SerializeObject(self, Converter.Settings);
}

internal static class Converter
{
    public static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
    {
        MetadataPropertyHandling = MetadataPropertyHandling.Ignore,
        DateParseHandling = DateParseHandling.None,
        Converters =
            {
                new IsoDateTimeConverter { DateTimeStyles = DateTimeStyles.AssumeUniversal }
            },
    };
}

internal class ParseStringConverter : JsonConverter
{
    public override bool CanConvert(Type t) => t == typeof(long) || t == typeof(long?);

    public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
    {
        if (reader.TokenType == JsonToken.Null) return null;
        var value = serializer.Deserialize<string>(reader);
        long l;
        if (Int64.TryParse(value, out l))
        {
            return l;
        }
        throw new Exception("Cannot unmarshal type long");
    }

    public override void WriteJson(JsonWriter writer, object untypedValue, JsonSerializer serializer)
    {
        if (untypedValue == null)
        {
            serializer.Serialize(writer, null);
            return;
        }
        var value = (long)untypedValue;
        serializer.Serialize(writer, value.ToString());
        return;
    }

    public static readonly ParseStringConverter Singleton = new ParseStringConverter();
}