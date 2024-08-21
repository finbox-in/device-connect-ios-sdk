//
//  FlowData.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import Foundation

struct FlowData: Decodable {
    let flowLocation: Bool
    let flowDevice: Bool
    
    enum CodingKeys: String, CodingKey {
        case flowLocation = "flow_location"
        case flowDevice = "flow_device"
    }
}
