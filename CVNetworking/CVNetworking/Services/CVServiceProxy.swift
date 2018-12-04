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

public protocol CVServiceProxy: class {
    
    /// 会话管理者，用来请求网络
    var sessionManager: SessionManager { get }
    
    /// 请求超时时间
    var timeout: TimeInterval { get }
    
    /// api的环境[开发，测试，预发布，发布]
    var apiEnvironment: CVApiEnvironment { set get }
    
    /// 网络连接状态，是否联网
    var isReachable: Bool { get }
    
    // MARK: -
    /// 基础域名
    var baseURL: String { get }
    
    /// 基础Header，一些默认，公共的header
    var baseHeaders: [String:String] { get }
    
    /// 基础的参数，一些默认的，公共的参数
    
    var baseParamters: [String:String] { get }
    
    /// 接口版本，若apiManager中同样设置了版本，则代替这里的字段
    var apiVersion: String { get }
    
    
    // MARK: - ~ 处理参数和常规错误
    /// 处理参数，本方法会在请求api之前调用，做最有的验证，修改，添加sign等
    func handleParamters(_ paramters: [String:String]) -> [String:String]
    
    /// 操作常规错误, 返回true,则会继续调用failure回调; 返回false,则不会调用failure回调, 一般处理一些token失效
    func handleError(error: Error?, errorType: CVNetworkingError) -> Bool
}

// MARK: - 网络请求，读取缓存
extension CVServiceProxy {

    /// 进行网络请求，返回DataRequest，根据Alamofire的链式响应，可以直接调用.response 的方法
    func callApi(with child: CVDataManagerChild) -> DataRequest {
        
        let url = generateURL(child: child)
        let headers = generateHeaders(child: child)
        let paramters = generateParamters(child: child)
        let HTTPMethod = generateHTTPMethod(child: child)
        
        // 请求之前打印一下GET方式的链接，方便观察
        #if DEBUG
        print(self.logDebug(url: url, paramters: paramters))
        #endif
        let dataRequest = sessionManager.request(url as URLConvertible, method: HTTPMethod, parameters: paramters, headers: headers)
        dataRequest.fullParams = paramters
        dataRequest.effectiveParams = child.paramters
        
        return dataRequest
    }
    
    /// 取缓存的数据
    func fetchDataFromCache(identifyer: String) -> CVURLResponse? {
        var response: CVURLResponse? = CVNetCache.share.fetchMemoryCache(identifyer: identifyer)
        if response == nil {
            response = CVNetCache.share.fetchDiskCache(identifyer: identifyer)
        }
        return response
    }
    
    /// 上传文件
    func uploadFile(with child: CVUploadManagerChild, complete: ((_ request: UploadRequest?, _ error: Error?)->())?) {
        
        let url = generateURL(child: child)
        let headers = generateHeaders(child: child)
        let paramters = generateParamters(child: child)
        let HTTPMethod = generateHTTPMethod(child: child)
        
        // 请求之前打印一下GET方式的链接，方便观察
        #if DEBUG
        print(self.logDebug(url: url, paramters: paramters))
        #endif
        sessionManager.upload(multipartFormData: { (formData) in
            for param in child.uploadParams {
                formData.append(param.fileData, withName: param.serverName, fileName: param.fileName, mimeType: param.MIMEType)
            }
            for (key, value) in paramters {
                formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, method: HTTPMethod, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .success(let request, _, _):
                complete?(request, nil)
            case .failure(let error):
                complete?(nil, error)
            }
        }
    }
}

// MARK: - Public Methods
extension CVServiceProxy {
    /// 返回请求的标识字符串
    func requestIdentifier(child: CVBaseManagerChild) -> String {
        var url: String = self.baseURL + "/" + self.apiVersion + "/" + child.methodName
        
        var paramters: [String:Any] = [String:Any]()
        for key in child.paramters.keys { paramters[key] = child.paramters[key] }
        

        url = handleURL(url)
        let str = SortedParamters(paramters).joined(separator: "&")
        if url.contains("?") {
            return (url + str).md5
        } else {
            return (url + "?" + str).md5
        }
    }
}

// MARK: - Private Methods
private extension CVServiceProxy {
    
    /// 生成URL
    func generateURL(child: CVBaseManagerChild) -> String {
        let url: String = self.baseURL + "/" + self.apiVersion + "/" + child.methodName
        // 处理url
        return handleURL(url)
    }
    
    /// 生成Headers
    func generateHeaders(child: CVBaseManagerChild) -> [String:String] {
        var headers: [String:String] = [:]
        for key in baseHeaders.keys { headers[key] = baseHeaders[key] }
        for key in child.headers.keys { headers[key] = child.headers[key] }
        return headers
    }
    
    /// 生成参数
    func generateParamters(child: CVBaseManagerChild) -> [String:String] {
        var paramters: [String:String] = [String:String]()
        for key in baseParamters.keys { paramters[key] = baseParamters[key] }
        for key in child.paramters.keys { paramters[key] = child.paramters[key] }
        
        // 处理参数
        paramters = handleParamters(paramters)
        return paramters
    }
    
    /// 生成请求的方式GET,POST
    func generateHTTPMethod(child: CVBaseManagerChild) -> HTTPMethod {
        // 处理HTTPMethod
        let HTTPMethod: HTTPMethod
        switch child.requestType {
        case .get:      HTTPMethod = .get
        case .post:     HTTPMethod = .post
        case .put:      HTTPMethod = .put
        case .delete:   HTTPMethod = .delete
        case .head:     HTTPMethod = .head
        }
        return HTTPMethod
    }
    
    /// 处理容错，防止域名和方法名之间出现"//"
    func handleURL(_ url: String) -> String {
        var result = url
        
        if url.contains("//") {
            result = url.replacingOccurrences(of: "//", with: "/")
            return handleURL(result)
        }
        
        return result.replacingOccurrences(of: ":/", with: "://")
    }
    
    // 打印请求链接
    @discardableResult
    func logDebug(url: String, paramters: [String:Any]) -> String {
        if url.contains("?") {
            return handleURL(url) + SortedParamters(paramters).joined(separator: "&")
        } else {
            return handleURL(url) + "?" + SortedParamters(paramters).joined(separator: "&")
        }
    }
}

