//
//  CVBaseApiManager.swift
//  CVNetworking
//
//  Created by caven on 2018/11/12.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit
import Alamofire


/// 本类封装了基础的网络请求，包括获取参数，监听网络请求的过程
open class CVBaseApiManager {

    public weak var delegate: CVBaseApiManagerDelegate?
    public weak var child: CVBaseApiManagerChild?
    
    public var isLoading: Bool { return getIsloading() }
    
    
    private var _isLoading = false
    private var requestIDList: [Int] = []
    
    init() {
        
        if let _ = self as? CVBaseApiManagerChild {
            self.child = self as? CVBaseApiManagerChild
        } else {
            assertionFailure("子类必须继承<CVBaseApiManagerChild>协议")
        }
    }
}

// MARK: - LifeCycle
extension CVBaseApiManager {
    
}

// MARK: - 公有方法
extension CVBaseApiManager {
    
    /// 加载数据，进行网络请求时直接调用此方法就可，返回请求ID
    @discardableResult
    func loadData() -> Int {
        
        return self.request()
    }
}

// MARK: - 私有方法
private extension CVBaseApiManager {
    
    /// 进行网络请求，并返回请求ID
    func request() -> Int {
        
        var requestID: Int = 0
        guard self.child != nil else { return requestID }
        
        let service = self.child!.service
        
        // 查看是否需要先读取缓存
        if self.child!.config.priority == .low {
            if let rr = service.fetchDataFromCache(identifyer: service.requestIdentifier(child: self.child!)) {
                self.handleSuccess(response: rr)
                return requestID
            }
        }
        
        // 进行实际的网络请求, 先判断是否联网
        if service.isReachable {
            _isLoading = true
            
            // 调起请求
            let dataRequest = service.callApi(with: self.child!)
            
            dataRequest.response { [weak self] (response: DefaultDataResponse) in
                
                guard let `self` = self else { return }
                
                let response = CVURLResponse.init(data: response.data, requestID: dataRequest.task?.taskIdentifier ?? 0, request: response.request!, error: response.error)
                response.effectiveParams = dataRequest.effectiveParams
                response.fullParams = dataRequest.fullParams
                
                if response.error == nil {
                    let config = self.child!.config
                    if config.openCache && config.cachePolicy.contains([.memory]) {
                        CVNetCache.share.saveMemoryCache(response: response, identifyer: service.requestIdentifier(child: self.child!), cacheTime: config.memoryCacheTime)
                    }
                    if config.openCache && config.cachePolicy.contains([.disk]) {
                        CVNetCache.share.saveDiskCache(response: response, identifyer: service.requestIdentifier(child: self.child!), cacheTime: config.diskCacheTime)
                    }
                    self.handleSuccess(response: response)
                } else {
                    
                    if self.child!.config.priority == .high {
                        if let rr = service.fetchDataFromCache(identifyer: service.requestIdentifier(child: self.child!)) {
                            self.handleSuccess(response: rr)
                        }
                    }
                    
                    var errorType: CVNetworkingError = .others
                    if let error = response.error as NSError? {
                        switch error.code {
                        case 404:   errorType = .webNotFind
                        case 408:   errorType = .timeout
                        case 503:   errorType = .serviceNotAvaliable
                        default:    errorType = .others
                        }
                    }
                    
                    if service.handleError(error: response.error, errorType: errorType) {
                        response.error?.errorType = errorType
                        self.handleFailed(response: response)
                    }
                }
            }
            
            requestID = dataRequest.task?.taskIdentifier ?? 0
        } else {
            
            if self.child!.config.priority == .high {
                if let rr = service.fetchDataFromCache(identifyer: service.requestIdentifier(child: self.child!)) {
                    self.handleSuccess(response: rr)
                }
            }
            // 没有网络
            let error = NSError(domain: service.baseURL, code: CVNetworkingError.noNetwork.rawValue, userInfo: [NSLocalizedDescriptionKey:"Loss network"]) as Error
            if service.handleError(error: error, errorType: .noNetwork) {
                let response = CVURLResponse(error: error)
                self.handleFailed(response: response)
            }
        }
        return requestID
    }
    
    
    /// 请求成功处理
    func handleSuccess(response: CVURLResponse) {
        _isLoading = false
        self.delegate?.requestDidSuccess(response: response)
    }
    
    /// 请求失败处理
    func handleFailed(response: CVURLResponse) {
        _isLoading = false
        self.delegate?.requestDidFailed(response: response)
    }
}


// MARK: - Getter Setter
private extension CVBaseApiManager {
    func getIsloading() -> Bool {
        if self.requestIDList.count == 0 {
            return false
        }
        return _isLoading
    }
}
