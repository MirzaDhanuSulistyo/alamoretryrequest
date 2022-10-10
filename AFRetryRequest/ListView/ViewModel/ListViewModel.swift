//
//  ListViewModel.swift
//  AFRetryRequest
//
//  Created by a.alami on 12/10/2020.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import Foundation
import Alamofire

class ListViewModel {
    func getData(_ completion: @escaping (Result<Data, CustomError>) -> Void) {
        //let token = UserDefaultsManager.shared.getToken()
        //let headers: HTTPHeaders = ["Device": getUUID() ?? ""]
        let url = "https://zenwel.indociti.com/api/admin/v1/id/myAccount/me"
        print("getData \(url)")
        print("device \(getUUID() ?? "")")
        print("Refresh-Token \(UserDefaultsManager.shared.getRefreshToken() ?? "")")
        NetworkManager.shared.request(url) { (result) in
            completion(result)
        }
    }
    
    func getCustomer(_ completion: @escaping (Result<Data, CustomError>) -> Void) {
        //let token = UserDefaultsManager.shared.getToken()
        //let headers: HTTPHeaders = ["Device": getUUID() ?? ""]
        let url = "https://zenwel.indociti.com/api/admin/v1/id/staff"
        print("getData \(url)")
        print("device \(getUUID() ?? "")")
        print("Refresh-Token \(UserDefaultsManager.shared.getRefreshToken() ?? "")")
        NetworkManager.shared.request(url) { (result) in
            completion(result)
        }
    }
    
    func logout(_ completion: @escaping (Result<Data, CustomError>) -> Void) {
        //let token = UserDefaultsManager.shared.getToken()
        //let headers: HTTPHeaders = ["Device": getUUID() ?? ""]
        let url = "https://zenwel.indociti.com/api/admin/v1/id/oauth/logout"
        print("logout \(url)")
        NetworkManager.shared.post(url) { (result) in
            completion(result)
        }
    }
    
    func getUUID() -> String? {
        
        // create a keychain helper instance
        let keychain = KeychainAccess()
        
        // this is the key we'll use to store the uuid in the keychain
        let uuidKey = "com.zenwel.ios.unique_uuid"
        
        // check if we already have a uuid stored, if so return it
        if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            return uuid
        }
        
        // generate a new id
        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }
        
        // store new identifier in keychain
        try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
        
        // return new id
        return newId
    }
}
