//
//  Request model for Location API
//
//


final class LocationModel: CommonRequest {
    
    var locationEntityList: [LocationEntity]?
    
    // Custom Initializer
    override init() {
        self.locationEntityList = nil
        super.init()
    }
    
    // Initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        locationEntityList = try container.decodeIfPresent([LocationEntity].self, forKey: .locationEntityList)
        try super.init(from: decoder)
    }
    
    // Method for encoding
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(locationEntityList, forKey: .locationEntityList)
        try super.encode(to: encoder)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case locationEntityList = "location"
    }
    
}
