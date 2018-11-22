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
@objc class CVBaseApiManager: NSObject {

    weak var delegate: CVBaseApiManagerDelegate?
    weak var child: CVBaseApiManagerChild?
    
    var isLoading: Bool { return getIsloading() }
    
    var cachePolicy: CVApiManagerCachePolicy = .noCache     // 缓存策略
    var memoryCacheSecond: TimeInterval = 3 * 60
    var diskCacheSecond: TimeInterval = 3 * 60
    var shouldIgnoreCache: Bool = false // 在有缓存的情况下，是否强制请求网络的控制开关，若为trur,则重新请求并根据缓存策略进行缓存
    
    var response: CVURLResponse?      // 请求结果
    
    private var _isLoading = false
    private var requestIDList: [Int] = []
    
    override init() {
        super.init()
        
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
        
        // 1. 获取参数params
        let params = self.child?.paramters
        
        // 3. 判断是否能够开启请求
        guard self.child != nil else { return requestID }
        
//        let serviceIdentifier = self.child!.service
        let service = self.child!.service
        let mothodName = self.child!.methodName
        
        var response: CVURLResponse?
        // 4. 先检查一下是否有内存缓存
        if shouldIgnoreCache == false && response != nil && cachePolicy.contains(.memory) {
            response = CVNetCache.share.fetchMemoryCache(serviceIdentifier: "asdfas", methodName: mothodName, params: params)
        }
        // 5. 先检查一下是否有硬盘缓存
        if shouldIgnoreCache == false && response != nil && cachePolicy.contains(.disk) {
            response = CVNetCache.share.fetchDiskCache(serviceIdentifier: "asdfasdfa", methodName: mothodName, params: params)
        }
        
        if response != nil { return requestID }
        
        // 6. 进行实际的网络请求, 先判断是否联网
        // 查找service服务，通过service挑起请求
//        let service = CVServiceFactory.share.fetchService(identifier: self.child!.serviceIdentifier)
        if service.isReachable {
            _isLoading = true
            
            // 调起请求
            let dataRequest = service.callApi(with: self.child!)
            
            dataRequest.response { [weak self] (response: DefaultDataResponse) in
                
                guard let `self` = self else { return }
                
                self.response = CVURLResponse.init(data: response.data, requestID: dataRequest.task?.taskIdentifier ?? 0, request: response.request!, error: response.error)
                self.response!.effectiveParams = dataRequest.effectiveParams
                self.response!.fullParams = dataRequest.fullParams
                
                if response.error == nil {
                    self.handleSuccess(response: self.response!)
                } else {
                    
                    var errorType: CVNetworkingError = .others
                    if let error = response.error as NSError? {
                        switch error.code {
                        case 404:
                            errorType = .webNotFind
                        case 408:
                            errorType = .timeout
                        case 503:
                            errorType = .serviceNotAvaliable
                        default:
                            errorType = .others
                            break
                        }
                    }
                    
                    if service.handleError(error: response.error, errorType: errorType) {
                        self.response!.error?.errorType = errorType
                        self.handleFailed(response: self.response!)
                    }
                }
            }
            
            requestID = dataRequest.task?.taskIdentifier ?? 0
        } else {
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
