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
open class CVBaseApiManager: CVBaseManager {

    public weak var delegate: CVBaseManagerDelegate?
    public weak var child: CVDataManagerChild?
    
    override init() {
        super.init()
        if let _ = self as? CVDataManagerChild {
            self.child = self as? CVDataManagerChild
        } else {
            assertionFailure("子类必须继承<CVDataManagerChild>协议")
        }
    }
}

// MARK: - 公有方法
extension CVBaseApiManager {
    
    /// 加载数据，进行网络请求时直接调用此方法就可，返回请求ID
    @discardableResult
    public func loadData() -> Int {
        return request()
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
                self.delegate?.requestDidSuccess(response: rr)
                return requestID
            }
        }
        
        // 进行实际的网络请求, 先判断是否联网
        if service.isReachable {
            
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
                    self.delegate?.requestDidSuccess(response: response)
                } else {
                    
                    if self.child!.config.priority == .high {
                        if let rr = service.fetchDataFromCache(identifyer: service.requestIdentifier(child: self.child!)) {
                            self.handleSuccess(response: rr)
                            self.delegate?.requestDidSuccess(response: response)
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
                        self.delegate?.requestDidFailed(response: response)
                    }
                }
            }
            
            requestID = dataRequest.task?.taskIdentifier ?? 0
            requestIDList.append(requestID)     // 记录请求ID
            taskList.append(dataRequest.task!)
        } else {
            
            if self.child!.config.priority == .high {
                if let rr = service.fetchDataFromCache(identifyer: service.requestIdentifier(child: self.child!)) {
                    self.handleSuccess(response: rr)
                    self.delegate?.requestDidSuccess(response: rr)
                }
            }
            // 没有网络
            let error = NSError(domain: service.baseURL, code: CVNetworkingError.noNetwork.rawValue, userInfo: [NSLocalizedDescriptionKey:"Loss network"]) as Error
            if service.handleError(error: error, errorType: .noNetwork) {
                let response = CVURLResponse(error: error)
                response.error?.errorType = .noNetwork
                self.handleFailed(response: response)
                self.delegate?.requestDidFailed(response: response)
            }
        }
        return requestID
    }
}
