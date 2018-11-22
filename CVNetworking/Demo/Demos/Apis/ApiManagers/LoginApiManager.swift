//
//  LoginApiManager.swift
//  CVNetworking
//
//  Created by caven on 2018/11/19.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

class LoginApiManager: CVBaseApiManager, CVBaseApiManagerChild {
    
    
    var methodName: String {
        return "login/login_in?format=json"
    }
    
    var paramters: [String : Any] {
        return ["email":"13133333333", "password":"111111"]
    }
    
    var service: CVServiceDelegate {
        return MainService.mainInstance
    }
    
    var serviceIdentifier: String {
        return MainService.identifier()
    }
    
    var requestType: CVRequestType {
        return .post
    }
    
    var headers: [String: String] {
        return [:]
    }
    var apiVersion: String {
        return "v2_0"
    }
}

extension LoginApiManager {
    static let share = LoginApiManager()
    
    
}

