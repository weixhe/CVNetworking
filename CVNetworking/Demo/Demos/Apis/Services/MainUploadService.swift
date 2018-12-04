//
//  MainUploadService.swift
//  CVNetworking
//
//  Created by caven on 2018/11/30.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation


class MainUploadService: CVService {
    static let instance = MainUploadService()
    
    override init() {
        super.init()
        
        #if DEBUG
        apiEnvironment = .develop
        #else
        apiEnvironment = .release
        #endif
        
        CVReachability.share.stateChanged { (state: CVNetworkState) in
            if state == .notReachable {
                ALERT(message: "没有网")
            }
        }
    }
    
    /// 域名
    override var baseURL: String {
        
        let _baseURL: String
        switch self.apiEnvironment {
        case .develop:      // 开发
            _baseURL = "http://api.fumubang.net"
        case .test:         // 测试
            _baseURL = "http://api.fumubang.net"
        case .adhoc:        // 预发布（线上测试）
            _baseURL = ""
        case .release:      // 发布
            _baseURL = ""
        }
        return _baseURL
    }
    
    override var apiVersion: String {
        return "v2_0"
    }
}
