//
//  HomeMsgApiManager.swift
//  CVNetworking
//
//  Created by caven on 2018/11/20.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

class HomeMsgApiManager: CVBaseApiManager, CVBaseApiManagerChild {
    var methodName: String {
        return "other/index_special_recommend_v32?format=json"
    }
    
    var paramters: [String : Any] {
        return ["city_id":1]
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
