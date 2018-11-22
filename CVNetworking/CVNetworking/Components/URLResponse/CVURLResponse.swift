//
//  CVURLResponse.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

public class CVURLResponse: NSObject {
    public var contentString: String { return getContentString() }
    public var responseObj: [String:Any] { return getResponseObj() }
    public var data: Data?
    
    public var error: Error?
    
    public var requestId: Int = 0
    public var request: URLRequest?
    
    public private(set) var isCache: Bool = false  // 用来判断数据是缓存数据，or 是请求的网络数据
    
    /// 有效的参数，即：出去公共参数之外，通过mananger的child提供
    var effectiveParams: Dictionary<String, Any>?
    /// 全部的参数，即：公共参数，通过service提供
    var fullParams: Dictionary<String, Any>?
}

// MARK: - Lift Cycle
public extension CVURLResponse {
    /// 初始化：只有数据，其他均默认，或为空
    /// 使用：从缓存中复原数据的情况下使用
    public convenience init(data: Data) {
        self.init()
        self.data = data
        self.isCache = true
    }
    
    /// 初始化：请求完成，创建一个response
    public convenience init(data: Data? = nil, requestID: Int = 0, request: URLRequest? = nil, error: Error?) {
        self.init()
        self.data = data
        self.requestId = requestID
        self.request = request
        self.isCache = false
        self.error = error
    }
    
}

// MARK: - Getter Setter
private extension CVURLResponse {
    
    func getContentString() -> String {
        guard let data = data  else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func getResponseObj() -> [String:Any] {
        let obj: [String:Any]
        do {
            guard let data = data  else { return [:] }
            obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
        } catch {
            obj = [:]
        }
        return obj
    }
    
}
