//
//  CVURLResponse.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class CVURLResponse: NSObject {
    var status: CVNetworkingError.RequestError?
    var contentString: String?
    var content: Dictionary<String, Any>?
    var responseData: Data {
        set {
            self.contentString = String(data: newValue, encoding: .utf8)
            self.content = try! JSONSerialization.jsonObject(with: newValue, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary
        }
        get {
            if self.contentString != nil {
                return self.contentString!.data(using: .utf8)!
            } else if self.content != nil {
                return try! JSONSerialization.data(withJSONObject: self.content!, options: .prettyPrinted)
            } else {
                return "".data(using: .utf8)!
            }
        }
    }
    var error: NSError?
    var requestId: Int = 0
    var request: NSURLRequest?
    private(set) var isCache: Bool = false  // 用来判断数据是否是缓存
    
    /// 初始化：只有数据，其他均默认，或为空
    /// 使用：从缓存中复原数据的情况下使用
    init(data: Data) {
        super.init()
        self.responseData = data
        self.status = self.responseStatus(with: nil)
        self.isCache = true
    }
    
    /// 初始化：请求完成，创建一个response
    init(responseStr: String?, responseObj: Dictionary<String, Any>?, requestID: Int, request: NSURLRequest, error: NSError?) {
        super.init()
        self.contentString = responseStr
        self.content = responseObj
        self.error = error
        self.requestId = requestID
        self.request = request
        self.status = self.responseStatus(with: error)
        self.isCache = false
    }
}

// MARK: - 私有方法
private extension CVURLResponse {
    private func responseStatus(with error: NSError?) -> CVNetworkingError.RequestError {
        if let error_ = error {
            var status = CVNetworkingError.RequestError.noNetwork
            
            switch error_.code {
            case NSURLErrorTimedOut:
                status = .timeout
            case NSURLErrorNotConnectedToInternet:
                status = .noNetwork
            case NSURLErrorCancelled:
                status = .cancel
            default:
                status = .noNetwork
            }
            return status
            
        }
        return .success
    }
    
}
