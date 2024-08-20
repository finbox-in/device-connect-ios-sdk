//
//  Response of Location API
//


struct LocationResponse: Decodable {
    
    let location: String
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
    }
    
}

