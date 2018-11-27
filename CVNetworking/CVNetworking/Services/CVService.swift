//
//  CVService.swift
//  CVNetworking
//
//  Created by caven on 2018/11/22.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/// 本类是提供请求的服务服务类，你可以继承并重写一些方法，以便完善请求服务， 也可以直接实现 CVServiceDelegate 类，创建你自己的服务类
open class CVService: CVServiceDelegate {
    
    
    lazy private var serviceInstance: SessionManager = SessionManager.default //{ return _serviceInstance() }()
    lazy private var _apiEnvironment: CVApiEnvironment = .develop
    
    
    public var sessionManager: SessionManager {
        return serviceInstance
    }
    
    public var timeout: TimeInterval {
        return 10
    }
    
    public var apiEnvironment: CVApiEnvironment {
        set {
            _apiEnvironment = newValue
        }
        get {
            return _apiEnvironment
        }
    }
    
    public var isReachable: Bool {
        return CVReachability.share.isReachable
    }
    
    public var baseURL: String {
        return ""
    }
    
    public var baseHeaders: HTTPHeaders {
        return [:]
    }
    
    public var baseParamters: [String : Any] {
        return [:]
    }

    public var apiVersion: String {
        return ""
    }
    
    public func handleParamters(_ paramters: [String : Any]) -> [String : Any] {
        return [:]
    }
    
    public func handleError(error: Error?, errorType: CVNetworkingError) -> Bool {
        return true
    }
}

//// MARK: - Private Methods
//fileprivate extension CVService {
//    /// 网络状态变化 监听通知
//    @objc func theNetworkDidChanged(note: Notification) {
//        let reachability = note.object as! Reachability
//        
//        switch reachability.connection {
//        case .wifi:
//            print("Reachable via WiFi")
//        case .cellular:
//            print("Reachable via Cellular")
//        case .none:
//            print("Network not reachable")
//        }
//    }
//}

// MARK: - Getter Setter
fileprivate extension CVService {
    
    func _serviceInstance() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = self.timeout
        return SessionManager(configuration: configuration)
    }
}

