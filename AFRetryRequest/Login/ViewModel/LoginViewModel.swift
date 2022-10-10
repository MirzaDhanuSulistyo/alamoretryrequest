//
//  LoginViewModel.swift
//  AFRetryRequest
//
//  Created by alireza.a on 11/10/2020.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import Foundation

public protocol ShowResult {
    func show(value:Int)
}

class LoginViewModel {
    
    var delegate: ShowResult?
    
    func loginLocation(apiKey: String, secretKey: String) {
        let parameters = ["grant_type": "password", "username": apiKey, "password": secretKey, "client_id": "4", "client_secret": "K6DIScZQiVfypZlgQYlGw1J8mWX69MoczCUY9zFm"]
        NetworkManager.shared.getLoginLoc(parameters: parameters) { (result) in
            switch result {
            case .success(let data):
                if let res = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) {
                    print("loginLocation vm \(res)")
                    self.login(apiKey: apiKey, secretKey: secretKey, token: res["access_token"] as! String)
                }
                /*if let token = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?["access_token"] as? String {
                    UserDefaultsManager.shared.signIn(apiKey: apiKey, secretKey: secretKey, token: token)
                }*/
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func login(apiKey: String, secretKey: String, token: String) {
        let parameters = ["grant_type": "password", "username": apiKey, "password": secretKey, "client_id": "4", "client_secret": "K6DIScZQiVfypZlgQYlGw1J8mWX69MoczCUY9zFm", "location_id": "566"]
        NetworkManager.shared.getLogin(token: token, parameters: parameters) { (result) in
            switch result {
            case .success(let data):
                if let res = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) {
                    print("login vm \(res)")
                }
                if let token = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?["access_token"] as? String, let refresh = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?["refresh_token"] as? String {
                    UserDefaultsManager.shared.signIn(apiKey: apiKey, secretKey: secretKey, token: token, refreshToken: refresh)
                    self.delegate?.show(value: 1)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
