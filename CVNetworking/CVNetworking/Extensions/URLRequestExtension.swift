//
//  URLRequestExtension.swift
//  CVNetworking
//
//  Created by caven on 2018/11/6.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

//extension URLRequest {
//    private struct ExtendKey {
//        static var effectiveParamsParams: String = ""
//        static var fullParams: String = ""
//        static var service: String = ""
//    }
//
//    /// 真实的参数
//    var effectiveParams: Dictionary<String, Any>? {
//        set {
//            objc_setAssociatedObject(self, ExtendKey.effectiveParamsParams, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            return objc_getAssociatedObject(self, ExtendKey.effectiveParamsParams) as? Dictionary<String, Any>
//        }
//    }
//
//    /// 原始的参数
//    var fullParams: Dictionary<String, Any>? {
//        set {
//            objc_setAssociatedObject(self, ExtendKey.fullParams, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            return objc_getAssociatedObject(self, ExtendKey.fullParams) as? Dictionary<String, Any>
//        }
//    }
//
//    /// service 服务
//    var service: CVServiceDelegate? {
//        set {
//            objc_setAssociatedObject(self, ExtendKey.service, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            return objc_getAssociatedObject(self, ExtendKey.service) as? CVServiceDelegate
//        }
//    }
//
//}
