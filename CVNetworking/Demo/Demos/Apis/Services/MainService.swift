//
//  MainService.swift
//  CVNetworking
//
//  Created by caven on 2018/11/9.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import Alamofire

/// 本类创建主服务
class MainService: CVService {
    static let mainInstance = MainService()
//    lazy var _apiEnvironment: CVApiEnvironment = .develop
//    lazy var _sessionManager: SessionManager = SessionManager.default
//}
//
//extension MainService /*: CVServiceDelegate*/ {
    
//    var sessionManager: SessionManager {
//        return _sessionManager
//    }
    
//    var apiEnvironment: CVApiEnvironment {
//        set {
//            _apiEnvironment = newValue
//        }
//        get {
//            return _apiEnvironment
//        }
//    }
    
//    override var instance: CVServiceDelegate {
//        return MainService.mainInstance
//    }
    
    /// 域名
    override var baseURL: String {
        
        let _baseURL: String
        switch self.apiEnvironment {
        case .develop:      // 开发
            _baseURL = "http://api.fumubang.net"
        case .test:         // 测试
            _baseURL = "http://api.fumubang.net"
        case .preRelese:    // 预发布（线上测试）
            _baseURL = "http://api.fumubang.com"
        case .release:      // 发布
            _baseURL = "http://api.fumubang.com"
        }
        return _baseURL
    }
    
//    /// 基础Header，一些默认，公共的header
//    var baseHeaders: HTTPHeaders {
//        return [:]
//    }
    
    /// 基础的参数，一些默认的，公共的参数
    override var baseParamters: [String:Any] {
        return ["idfa":"A966D0E2-D98A-40E7-8D29-40B92199648A",
                "req_sec":"1542705146",
                "version":"3.96",
                "opversion":"ios12.1",
                "deviceType":"Simulator",
                "language":"zh",
                ]
    }
    
//    var apiVersion: String {
//        return ""
//    }
    
    /// 最后处理参数
    override func handleParamters(_ paramters: [String : Any]) -> [String : Any] {
        
        let appID = "638481987"
        let appKey = "65GdQcKY6Q1a1eESEtGt7nNBxqWkapzb"
        
        // 先将params按照key排序
        let sortParams = paramters.sorted { (str1, str2) -> Bool in
            return str1.key < str2.key
        }
        // 将params中的key和value拼接起来，返回到数组中
        let paramStrings = sortParams.map { (str) -> String in
            return "\(str.key)=\(str.value)"
        }
        
        // 将params转换成字符串
        let str = paramStrings.joined(separator: "&")
        
        // 字符串 拼接 key，完成签名
        let sign = (str + appKey).md5
        
        // 最后，将签名好的字符串 和 appID 添加到参数中，并返回最终参数
        var newParams = paramters
        newParams["sign"] = sign
        newParams["appid"] = appID
        
        return newParams
    }
    
    override func handleError(error: Error?, errorType: CVNetworkingError) -> Bool {
        switch errorType {
        case .noNetwork:
            print("===== 没有网络 =====")
            return false
        case .webNotFind:
            print("===== 没有找到网络 =====")
            return false
        case .serviceNotAvaliable:
            print("===== 服务不可用 =====")
            return false
        case .timeout:
            print("===== 请求超时 =====")
            return false
        case .cancel:
            print("===== 取消请求 =====")
            return false
        default:
            
            print(error?.localizedDescription ?? "")
            
            return true
        }
    }
}
