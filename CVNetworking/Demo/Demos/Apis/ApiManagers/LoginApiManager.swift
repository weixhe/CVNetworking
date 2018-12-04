//
//  LoginApiManager.swift
//  CVNetworking
//
//  Created by caven on 2018/11/19.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

class LoginApiManager: CVBaseApiManager, CVDataManagerChild {
    
    
    var methodName: String {
        return "login/login_in?format=json"
    }
    
    var paramters: [String : String] {
        return ["email":"13133333333", "password":"111111"]
    }
    
    var service: CVServiceProxy {
        return MainService.instance
    }
    
    var requestType: CVRequestType {
        return .post
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    
}

extension LoginApiManager {
    static let share = LoginApiManager()
    
    
}
