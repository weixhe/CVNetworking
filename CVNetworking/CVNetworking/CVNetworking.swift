//
//  CVNetworking.swift
//  CVNetworking
//
//  Created by caven on 2018/11/9.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import Alamofire

/// api 的网络环境
public enum CVApiEnvironment {
    case develop    // 开发
    case test       // 测试
    case preRelese  // 预发布（线上测试）
    case release    // 发布
}

public enum CVRequestType: String {
    case get        = "GET"
    case post       = "POST"
    case put        = "PUT"
    case delete     = "DELETE"
    case head       = "HEAD"
}

extension CVRequestType {
    
}


@objc public enum CVNetworkingError: Int {
    
    case `default` = 0                  // 默认没有请求
    //case success = 200                  // 请求成功，返回正确数据
    case webNotFind = 404               // 网页不存在
    case timeout = 408                  // 超时，默认20s
    case serviceNotAvaliable = 503      // 服务不可用
    case noNetwork = 2001               // 默认除了超时以外的错误都是无网络错误
    case cancel = 2002                  // 取消
    
    case others = 3000                  // 其他错误
}


/// 缓存策略
struct CVApiManagerCachePolicy: OptionSet {
    
    var rawValue: UInt
    
    static var noCache = CVApiManagerCachePolicy(rawValue: 0)
    static var memory = CVApiManagerCachePolicy(rawValue: 1 << 1)
    static var disk = CVApiManagerCachePolicy(rawValue: 1 << 2)
}


/*****************************************************************/
/**                                扩展                           */
/*****************************************************************/

struct ExtendKey {
    static let errorType = "errorType"
    
    static var effectiveParamsParams: String = ""
    static var fullParams: String = ""
    static var service: String = ""
}
extension Error {
    
    var errorType: CVNetworkingError {
        get {
            return objc_getAssociatedObject(self, ExtendKey.errorType) as? CVNetworkingError ?? .default
        }
        set {
            objc_setAssociatedObject(self, ExtendKey.errorType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension Dictionary {
    
    /// 将字典中的数据转换成，拼接成一个字符串
    func transformToUrlParamString() -> String {
        var result = ""
        
        var index = 0
        for (key, value) in self {
            if index == 0 {
                result = "?\(key)=\(value)"
            } else {
                result += "&\(key)=\(value)"
            }
            index += 1
        }
        return result
    }
    
    /// 将字典中的keys按照字母排序
    
}

extension Request {
    
    /// 有效的参数
    var effectiveParams: Dictionary<String, Any>? {
        set {
            objc_setAssociatedObject(self, ExtendKey.effectiveParamsParams, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, ExtendKey.effectiveParamsParams) as? Dictionary<String, Any>
        }
    }
    
    /// 原始的参数
    var fullParams: Dictionary<String, Any>? {
        set {
            objc_setAssociatedObject(self, ExtendKey.fullParams, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, ExtendKey.fullParams) as? Dictionary<String, Any>
        }
    }
    
    /// service 服务
    var service: CVServiceDelegate? {
        set {
            objc_setAssociatedObject(self, ExtendKey.service, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, ExtendKey.service) as? CVServiceDelegate
        }
    }
    
}


