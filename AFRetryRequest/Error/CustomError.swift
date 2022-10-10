//
//  CustomError.swift
//  AFRetryRequest
//
//  Created by alireza.a on 11/10/2020.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import Foundation
enum CustomError: String, Error {
    case authorize = "Unable to authenticate user. An error occurred during authorization, please check your connection and try again."
    case unavailableServer = "Server is unavailable"
}
