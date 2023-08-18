//
//  LocalStorage.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import Foundation

final class LocalStorage {
    private init() {}
    static let shared = LocalStorage()
    
    var countryCode: String? {
        get {
            return UserDefaults.standard.value(forKey: "country_code") as? String
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "country_code")
        }
    }
    
    var userNumber: String? {
        get {
            return UserDefaults.standard.value(forKey: "phone_number") as? String
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "phone_number")
        }
    }
    
    var authToken: String? {
        get {
            return UserDefaults.standard.value(forKey: "auth_token") as? String
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "auth_token")
        }
    }
    
}
