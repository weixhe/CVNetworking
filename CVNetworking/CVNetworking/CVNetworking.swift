//
//  CVNetworking.swift
//  CVNetworking
//
//  Created by caven on 2018/11/9.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CommonCrypto

/// api 的网络环境
public enum CVApiEnvironment {
    case develop    // 开发
    case test       // 测试
    case adhoc      // 预发布（线上测试）
    case release    // 发布
}

public enum CVRequestType: String {
    case get        = "GET"
    case post       = "POST"
    case put        = "PUT"
    case delete     = "DELETE"
    case head       = "HEAD"
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
public struct CVApiManagerCachePolicy: OptionSet {
    
    public var rawValue: UInt
    
    static var noCache = CVApiManagerCachePolicy(rawValue: 0)
    static var memory = CVApiManagerCachePolicy(rawValue: 1 << 1)
    static var disk = CVApiManagerCachePolicy(rawValue: 1 << 2)
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

/// 请求优先级
public enum CVNetworkingPriority: Int {
    case required = 1            // 只进行请求网络，数据同步较及时
    case high = 2                // 网络请求优先级较高，安全性较高，请求失败后会尝试提取缓存
    case low = 3                 // 默认属性，网络请求优先级较低，性能较高，有缓存取缓存，无缓存再请求
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

// MARK: -
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

/// 将字典中的keys按照字母排序并用‘=’拼接，返回数组
func SortedParamters(_ paramters: [String:Any], asc: Bool = true) -> [String] {
    
    guard paramters.count > 0 else { return [] }
    // 先将params按照key排序
    let sortParams = paramters.sorted { (str1, str2) -> Bool in
        return str1.key < str2.key
    }
    // 将params中的key和value拼接起来，返回到数组中
    return sortParams.map { (str) -> String in
        return "\(str.key)=\(str.value)"
    }
}

// MARK: -
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




extension String  {
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        return stringFromResult(result, length: digestLen)
    }
    
    private func stringFromResult(_ bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        free(bytes)
        return String(format: hash as String)
    }
}
