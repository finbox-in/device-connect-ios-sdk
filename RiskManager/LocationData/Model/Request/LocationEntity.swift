//
//  Model used to be save Location details
//
//


class LocationEntity: Codable {
    
    var id: String?
    
    var latitude: Double?
    
    var longitude: Double?
    
    var accuracy: Double?
    
    var time: Int64?

    
    init() {
        self.id = nil
        self.latitude = nil
        self.longitude = nil
        self.accuracy = nil
        self.time = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "hash"
        case latitude = "latitude"
        case longitude = "longitude"
        case accuracy = "accuracy"
        case time = "timeInMillis"
    }
    
}
