//
//  NSURLRequestExtension.swift
//  CVNetworking
//
//  Created by caven on 2018/11/6.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

extension NSURLRequest {
    private struct ExtendKey {
        static var keyForActualRequestParams: String = ""
        static var keyForOriginalRequestParams: String = ""
    }
    
    /// 真实的参数
    var actualRequestParams: Dictionary<String, Any>? {
        set {
            objc_setAssociatedObject(self, ExtendKey.keyForActualRequestParams, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, ExtendKey.keyForActualRequestParams) as? Dictionary<String, Any>
        }
    }
    
    /// 原始的参数
    var originalRequestParams: Dictionary<String, Any>? {
        set {
            objc_setAssociatedObject(self, ExtendKey.keyForOriginalRequestParams, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, ExtendKey.keyForOriginalRequestParams) as? Dictionary<String, Any>
        }
    }
    
}
