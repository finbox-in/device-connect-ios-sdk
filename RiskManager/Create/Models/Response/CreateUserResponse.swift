//
//  CreateUserResponse.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import Foundation

struct CreateUserResponse: Decodable {
    
    let status: String
    let message: String?
    let accessToken: String?
    let isDataReset: Bool?
    let username: String
    let userHash: String
    let flowData: FlowData?
    let isCancelSync: Bool?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case accessToken = "access_token"
        case isDataReset = "data_reset"
        case username = "username"
        case userHash = "user_hash"
        case flowData = "flow_data"
        case isCancelSync = "cancel_sync"
    }

}

