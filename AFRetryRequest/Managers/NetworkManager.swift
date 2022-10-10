//
//  NetworkManager.swift
//  AFRetryRequest
//
//  Created by alireza.a on 11/10/2020.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import Alamofire
import UIKit

class NetworkManager {
    static let shared: NetworkManager = {
        return NetworkManager()
    }()
    typealias completionHandler = ((Result<Data, CustomError>) -> Void)
    var request: Alamofire.Request?
    let retryLimit = 3
    
    let baseUrl = "https://zenwel.indociti.com/api/admin/v1/id/"
    
    func getLoginLoc(parameters: [String: Any]?, completion: @escaping completionHandler) {
        print("getLoginLoc | oauth/getLoc")
        request?.cancel()
        request = AF.request(baseUrl + "oauth/getLoc", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let data = response.data {
                completion(.success(data))
            } else {
                completion(.failure(.unavailableServer))
            }
        }
    }
    
    func getLogin(token: String, parameters: [String: Any]?, completion: @escaping completionHandler) {
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)", "Device": getUUID() ?? ""]
        print("getLogin | oauth/newtoken")
        request?.cancel()
        request = AF.request(baseUrl + "oauth/newtoken", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let data = response.data {
                completion(.success(data))
            } else {
                completion(.failure(.unavailableServer))
            }
        }
    }
    
    func request(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil,
                 interceptor: RequestInterceptor? = nil, completion: @escaping completionHandler) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding,
                   headers: headers, interceptor: interceptor ?? self).validate().responseJSON { (response) in
            if let data = response.data {
                completion(.success(data))
            } else {
                completion(.failure(.unavailableServer))
            }
        }
    }
    
    func post(_ url: String, method: HTTPMethod = .post, parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil,
                 interceptor: RequestInterceptor? = nil, completion: @escaping completionHandler) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding,
                   headers: headers, interceptor: interceptor ?? self).validate().responseJSON { (response) in
            if let data = response.data {
                completion(.success(data))
            } else {
                completion(.failure(.unavailableServer))
            }
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
