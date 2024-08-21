//
//  Contains Common keys send in the API
//
//


class CommonRequest: Codable {
    
    var batchId: String?
    
    var username: String?
    
    var userHash: String?
    
    var sdkVersionName: String?
    
    var syncId: Int64?
    
    var syncMechanism: Int?
    
    var isRealTime: Bool?
    
    init() {
        self.batchId = nil
        self.username = nil
        self.userHash = nil
        self.sdkVersionName = nil
        self.syncId = nil
        self.syncMechanism = nil
        self.isRealTime = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case batchId = "batchId"
        case username = "username"
        case userHash = "userHash"
        case sdkVersionName = "sdkVersionName"
        case syncId = "syncId"
        case syncMechanism = "syncMechanism"
        case isRealTime = "isRealTime"
    }
    
}
