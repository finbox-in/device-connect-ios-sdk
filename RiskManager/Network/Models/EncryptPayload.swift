//
//  EncryptPayload.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import Foundation

struct EncryptPayload: Codable {
    let iv: String
    let cipherText: String
    let paddingLength: Int32 = 0
    
    init(iv: String, cipherText: String) {
        self.iv = iv
        self.cipherText = cipherText
    }
    
    enum CodingKeys: String, CodingKey {
        case iv = "iv"
        case cipherText = "ciphertext"
        case paddingLength = "padding_length"
    }
}
