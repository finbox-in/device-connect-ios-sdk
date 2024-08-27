//
// Device Information Request Model class
//

class DeviceInfo: CommonRequest {
    
    var hash: String?
    var manufacturer: String?
    var model: String?
    var ramAvailable: Int64?
    var totalRam: Int64?
    var availableInternalSize: Int64?
    var totalInternalSize: Int64?
    var displayLanguage: String?
    var networkType: String?
    var osVersion: String?
    var iosId: String?
    var fingerprint: String?
    var brand: String?
    var device: String?
    var ssid: String?
    var elapsedTimeMillis: Int64?
    var reason: String?
    var typeName: String?
    var sIndex: Int?
    var sCarrierName: String?
    var sCountryIso: String?
    var widthPixels: Int?
    var heightPixels: Int?
    var advertisingId: String?
    var rootFlag: Bool?
    
    // Custom Initializer
    override init() {
        self.hash = nil
        self.manufacturer = nil
        self.model = nil
        self.ramAvailable = nil
        self.totalRam = nil
        self.availableInternalSize = nil
        self.totalInternalSize = nil
        self.displayLanguage = nil
        self.networkType = nil
        self.osVersion = nil
        self.iosId = nil
        self.fingerprint = nil
        self.brand = nil
        self.device = nil
        self.ssid = nil
        self.elapsedTimeMillis = nil
        self.reason = nil
        self.typeName = nil
        self.sIndex = nil
        self.sCarrierName = nil
        self.sCountryIso = nil
        self.widthPixels = nil
        self.heightPixels = nil
        self.advertisingId = nil
        self.rootFlag = nil
        super.init()
    }
    
    // Initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hash = try container.decodeIfPresent(String.self, forKey: .hash)
        manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer)
        model = try container.decodeIfPresent(String.self, forKey: .model)
        ramAvailable = try container.decodeIfPresent(Int64.self, forKey: .ramAvailable)
        totalRam = try container.decodeIfPresent(Int64.self, forKey: .totalRam)
        availableInternalSize = try container.decodeIfPresent(Int64.self, forKey: .availableInternalSize)
        totalInternalSize = try container.decodeIfPresent(Int64.self, forKey: .totalInternalSize)
        displayLanguage = try container.decodeIfPresent(String.self, forKey: .displayLanguage)
        networkType = try container.decodeIfPresent(String.self, forKey: .networkType)
        osVersion = try container.decodeIfPresent(String.self, forKey: .osVersion)
        iosId = try container.decodeIfPresent(String.self, forKey: .iosId)
        fingerprint = try container.decodeIfPresent(String.self, forKey: .fingerprint)
        brand = try container.decodeIfPresent(String.self, forKey: .brand)
        device = try container.decodeIfPresent(String.self, forKey: .device)
        ssid = try container.decodeIfPresent(String.self, forKey: .ssid)
        elapsedTimeMillis = try container.decodeIfPresent(Int64.self, forKey: .elapsedTimeMillis)
        reason = try container.decodeIfPresent(String.self, forKey: .reason)
        typeName = try container.decodeIfPresent(String.self, forKey: .typeName)
        sIndex = try container.decodeIfPresent(Int.self, forKey: .sIndex)
        sCarrierName = try container.decodeIfPresent(String.self, forKey: .sCarrierName)
        sCountryIso = try container.decodeIfPresent(String.self, forKey: .sCountryIso)
        widthPixels = try container.decodeIfPresent(Int.self, forKey: .widthPixels)
        heightPixels = try container.decodeIfPresent(Int.self, forKey: .heightPixels)
        advertisingId = try container.decodeIfPresent(String.self, forKey: .advertisingId)
        rootFlag = try container.decodeIfPresent(Bool.self, forKey: .rootFlag)
        try super.init(from: decoder)
    }
    
    // Method for encoding
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(hash, forKey: .hash)
        try container.encodeIfPresent(manufacturer, forKey: .manufacturer)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(ramAvailable, forKey: .ramAvailable)
        try container.encodeIfPresent(totalRam, forKey: .totalRam)
        try container.encodeIfPresent(availableInternalSize, forKey: .availableInternalSize)
        try container.encodeIfPresent(totalInternalSize, forKey: .totalInternalSize)
        try container.encodeIfPresent(displayLanguage, forKey: .displayLanguage)
        try container.encodeIfPresent(networkType, forKey: .networkType)
        try container.encodeIfPresent(osVersion, forKey: .osVersion)
        try container.encodeIfPresent(iosId, forKey: .iosId)
        try container.encodeIfPresent(fingerprint, forKey: .fingerprint)
        try container.encodeIfPresent(brand, forKey: .brand)
        try container.encodeIfPresent(device, forKey: .device)
        try container.encodeIfPresent(ssid, forKey: .ssid)
        try container.encodeIfPresent(elapsedTimeMillis, forKey: .elapsedTimeMillis)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encodeIfPresent(typeName, forKey: .typeName)
        try container.encodeIfPresent(sIndex, forKey: .sIndex)
        try container.encodeIfPresent(sCarrierName, forKey: .sCarrierName)
        try container.encodeIfPresent(sCountryIso, forKey: .sCountryIso)
        try container.encodeIfPresent(widthPixels, forKey: .widthPixels)
        try container.encodeIfPresent(heightPixels, forKey: .heightPixels)
        try container.encodeIfPresent(advertisingId, forKey: .advertisingId)
        try container.encodeIfPresent(rootFlag, forKey: .rootFlag)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case hash = "hash"
        case manufacturer = "manufacturer"
        case model = "mobile_model"
        case ramAvailable = "available_ram"
        case totalRam = "total_ram"
        case availableInternalSize = "available_internal_storage"
        case totalInternalSize = "total_internal_storage"
        case displayLanguage = "display_language"
        case networkType = "network_type"
        case osVersion = "os_version"
        case iosId = "ios_id"
        case fingerprint = "device_fingerprint"
        case brand = "brand"
        case device = "device"
        case ssid = "wifi_ssid"
        case elapsedTimeMillis = "elapsed_time_millis"
        case reason = "active_network_reason"
        case typeName = "active_network_type_name"
        case widthPixels = "widthPixels"
        case heightPixels = "heightPixels"
        case sIndex = "sim_slot_index_1"
        case sCarrierName = "sim_carrier_name_1"
        case sCountryIso = "sim_country_iso_1"
        case advertisingId = "advertising_id"
        case rootFlag = "root_flag"
    }
    
}
