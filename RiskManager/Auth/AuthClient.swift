//
//  AuthClient.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import CommonCrypto
import Foundation

class AuthClient {
    
    /// Compute the salt
    func getSalt(customerId: String) -> String {
        // Current Time in Seconds
        let time = currentTimeInSec()
        // Find the length
        let timeLength = time.count
        // Find the mid length
        let timeMid = timeLength / 2
        // Build the first half of the time
        let halfIndex = time.index(time.startIndex, offsetBy: timeMid)
        
        let startTime = Int(String(time[..<halfIndex]))! * 3
        var endTimeString = String(time[halfIndex...])
        
        // Count the zeros that are at the start of the end time string
        var zeroCount = 0
        for element in endTimeString {
            if (element == "0") {
                zeroCount += 1
            } else {
                break
            }
        }
        
        let endTime = Int(endTimeString)! * 7
        endTimeString = String(endTime)
        
        for _ in 0..<zeroCount {
            endTimeString = "0\(endTimeString)"
        }
        
        return "\(startTime)\(generateRandomChar())\(CommonUtil.get256Encoded(message: customerId + readSalt() + time)!)\(generateRandomChar())\(endTimeString)"
    }
    
    func readSalt() -> String {
        return CommonUtil.getBase64Decode(text: getClientSalt())
    }
    
    func getClientSalt() -> String {
        return "MXJIODh6ZjJYcnFabW1JYW1HZDB4bm5wUFN0MkgzTmFzRDFmeVl6M2JybkVFRE1YZ08yMUtRdw=="
    }
    
    
    func generateRandomChar() -> Character {
        return Character(UnicodeScalar(Int.random(in: 58..<123))!)
    }
    
    func currentTimeInSec() -> String {
        return Int(Date().timeIntervalSince1970).description
    }
    
}

