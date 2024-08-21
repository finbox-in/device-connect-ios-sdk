//
//  API Payload when sending Batch Data
//
//


class BatchData<T: Codable>: CommonRequest {
    
    /**
     * Array that contains the batch list
     */
    var batchArray: [T]?
    
    /**
     * Batch number
     */
    var batchNumber: Int?
    
    /**
     * Batch count
     */
    var batchCount: Int?
    
    // Initializer
    override init() {
        self.batchNumber = nil
        self.batchCount = nil
        super.init() // Call to the initializer of the superclass
    }
    
    // Required initializer for decoding
    required init(from decoder: Decoder) throws {
        // Call the superclass initializer
        try super.init(from: decoder)
        
        // Create a container for decoding the properties
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode properties
        batchArray = try container.decode([T].self, forKey: .batchArray)
        batchNumber = try container.decodeIfPresent(Int.self, forKey: .batchNumber)
        batchCount = try container.decodeIfPresent(Int.self, forKey: .batchCount)
    }
    
    // Encoding function
    override func encode(to encoder: Encoder) throws {
        // Call the superclass encode method
        try super.encode(to: encoder)
        
        // Create a container for encoding the properties
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode properties
        try container.encode(batchArray, forKey: .batchArray)
        try container.encodeIfPresent(batchNumber, forKey: .batchNumber)
        try container.encodeIfPresent(batchCount, forKey: .batchCount)
    }
    
    enum CodingKeys: String, CodingKey {
        case batchArray = "data"
        case batchNumber = "batchNumber"
        case batchCount = "batchCount"
    }
    
}


