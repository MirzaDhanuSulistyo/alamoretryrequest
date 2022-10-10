//
//  NetworkManager+RequestInterceptor.swift
//  AFRetryRequest
//
//  Created by alireza.a on 11/10/2020.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import Alamofire
extension NetworkManager: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let token = UserDefaultsManager.shared.getToken() else {
            completion(.success(urlRequest))
            return
        }
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.setValue(getUUID() ?? "", forHTTPHeaderField: "device")
        print("\nadapted; token added to the header field is: \(bearerToken)\n")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        let response = request.task?.response as? HTTPURLResponse
        print("\nretried; response code: \(response?.statusCode ?? 0)\n")
        if let statusCode = response?.statusCode, statusCode == 401 {
            print("\nretried; retry count: \(request.retryCount)\n")
            refreshToken { isSuccess in
                //isSuccess ? completion(.retry) : completion(.doNotRetry)
                completion(.retry)
            }
        }
    }
    
    func refreshToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let token = UserDefaultsManager.shared.getToken(), let refreshToken = UserDefaultsManager.shared.getRefreshToken() else { return }
        let parameters = ["grant_type": "refresh_token", "client_id": "4", "client_secret": "K6DIScZQiVfypZlgQYlGw1J8mWX69MoczCUY9zFm", "refresh_token": refreshToken]
        
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)", "Device": getUUID() ?? ""]
        
        AF.request("https://zenwel.indociti.com/api/admin/v1/id/oauth/clienttoken", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                if let error = response.object(forKey: "error") as? Int {
                    if error == 0 {
                        let token = response.object(forKey: "access_token") as! String
                        let refreshToken = response.object(forKey: "refresh_token") as! String
                        UserDefaultsManager.shared.setToken(token: token)
                        UserDefaultsManager.shared.setRefreshToken(token: refreshToken)
                        print("\nRefresh token completed successfully. New token is: \(token)\n")
                        print("\nRefresh token completed successfully. \(response)\n")
                        completion(true)
                    } else {
                        print("\nRefresh token - ERROR* \(JSON)")
                        completion(false)
                    }
                } else {
                    print("\nRefresh token - ERROR** \(JSON)")
                    completion(false)
                }
            case .failure(let error):
                print("\nRefresh token - ERROR \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
}
