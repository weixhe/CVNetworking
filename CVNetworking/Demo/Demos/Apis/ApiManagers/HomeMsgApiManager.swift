//
//  HomeMsgApiManager.swift
//  CVNetworking
//
//  Created by caven on 2018/11/20.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

class HomeMsgApiManager: CVBaseApiManager, CVDataManagerChild {
    var methodName: String {
        return "other/index_special_recommend_v32?format=json"
    }
    
    var paramters: [String : String] {
        return ["city_id":"1"]
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
    
    
    var config: CVConfiguration {
        var config = CVConfiguration()
        config.cachePolicy = [.memory, .disk]
        config.priority = .low
        return config
    }
    
}
