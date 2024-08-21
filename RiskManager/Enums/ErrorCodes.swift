//
//  ErrorCodes.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 12/08/24.
//

import Foundation


public enum FinBoxErrorCode: Int {
    case QUOTA_LIMIT_EXCEEDED = 7670
    case AUTHENTICATE_FAILED = 7671
    case AUTHENTICATE_API_FAILED = 7672
    case AUTHORIZATION_API_FAILED = 7673
    case NO_ACTIVE_NETWORK = 7678
    case NETWORK_TIME_OUT = 7679
    case NETWORK_RESPONSE_NULL = 7681
    case USER_TOKENS_NULL = 7682
    case ACCESS_TOKEN_NULL = 7683
    case REFRESH_TOKEN_NULL = 7684
    case AUTHENTICATE_NOT_FOUND = 7685
    case ENCODE_FORMAT_ERROR = 7686
}
