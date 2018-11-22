//
//  CVServiceDelegate.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import Alamofire

/// 回调方法
typealias CVCallBack = (_ response: CVURLResponse) -> Void
typealias CVCallBackError = (_ error: NSError) -> Void

public protocol CVServiceDelegate: class {
    
//    /// 创建单例, 实现此属性时请返回一个单例对象
//    var instance: CVServiceDelegate { get }
    
    /// 会话管理者，用来请求网络
    var sessionManager: SessionManager { get }
    /// api的环境[开发，测试，预发布，发布]
    var apiEnvironment: CVApiEnvironment { set get }
    /// 网络连接状态，是否联网
    var isReachable: Bool { get }
    
    // MARK: -
    /// 基础域名
    var baseURL: String { get }
    /// 基础Header，一些默认，公共的header
    var baseHeaders: HTTPHeaders { get }
    /// 基础的参数，一些默认的，公共的参数
    var baseParamters: [String:Any] { get }
    /// 接口版本，若apiManager中同样设置了版本，则代替这里的字段
    var apiVersion: String { get }
    
    
    // MARK: - ~ 处理参数和常规错误
    /// 处理参数，本方法会在请求api之前调用，做最有的验证，修改，添加sign等
    func handleParamters(_ paramters: [String:Any]) -> [String:Any]
    
    /// 操作常规错误, 返回true,则会继续调用failure回调; 返回false,则不会调用failure回调, 一般处理一些token失效
    func handleError(error: Error?, errorType: CVNetworkingError) -> Bool
}

// MARK: -
extension CVServiceDelegate {
    static func identifier() -> String {
        return NSStringFromClass(Self.self)
    }
    
    /// 基础Header，一些默认，公共的header
    var baseHeaders: HTTPHeaders {
        return [:]
    }
    /// 基础的参数，一些默认的，公共的参数
    var baseParams: [String:Any] {
        return [:]
    }
    
    var apiVersion: String {
        return ""
    }
    
    /// 进行网络请求，返回DataRequest，根据Alamofire的链式响应，可以直接调用.response 的方法
    func callApi(with child: CVBaseApiManagerChild) -> DataRequest {
        
        let apiVer: String = child.apiVersion.count > 0 ? child.apiVersion : self.apiVersion.count > 0 ? self.apiVersion : ""
        var url: String = self.baseURL + "/" + apiVer + "/" + child.methodName
        
        
        var headers: HTTPHeaders = HTTPHeaders()
        for key in baseHeaders.keys { headers[key] = baseHeaders[key] }
        for key in child.headers.keys { headers[key] = child.headers[key] }
        
        var paramters: [String:Any] = [String:Any]()
        for key in baseParamters.keys { paramters[key] = baseParamters[key] }
        for key in child.paramters.keys { paramters[key] = child.paramters[key] }
 
        // 处理url
        url = handleURL(url)
        
        // 处理参数
        paramters = handleParamters(paramters)
        
        // 处理HTTPMethod
        let HTTPMethod: HTTPMethod
        switch child.requestType {
        case .get:
            HTTPMethod = .get
        case .post:
            HTTPMethod = .post
        case .put:
            HTTPMethod = .put
        case .delete:
            HTTPMethod = .delete
        case .head:
            HTTPMethod = .head
        }
        
        let dataRequest = sessionManager.request(url as URLConvertible, method: HTTPMethod, parameters: paramters, headers: headers)
        dataRequest.fullParams = paramters
        dataRequest.effectiveParams = child.paramters
        
        return dataRequest
    }
}

private extension CVServiceDelegate {
    // 处理容错，防止域名和方法名之间出现"//"
    func handleURL(_ url: String) -> String {
        var result = url
        
        if url.contains("//") {
            result = url.replacingOccurrences(of: "//", with: "/")
            return handleURL(result)
        }
        
        return result.replacingOccurrences(of: ":/", with: "://")
    }
}
