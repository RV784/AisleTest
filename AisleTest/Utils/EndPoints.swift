//
//  EndPoints.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import Foundation

class APIBaseUrl {
    private init() {}
    static let shared = APIBaseUrl()
    var baseUrl = "https://app.aisle.co/V1"
}

enum EndPoints: CustomStringConvertible {
    case phoneLogin
    case verifyOtp
    case getNotes
    
    var description: String {
        switch self {
            
        case .phoneLogin:
            return "\(APIBaseUrl.shared.baseUrl)/users/phone_number_login"
        case .verifyOtp:
            return "\(APIBaseUrl.shared.baseUrl)/users/verify_otp"
        case .getNotes:
            return "\(APIBaseUrl.shared.baseUrl)/users/test_profile_list"
        }
    }
}
