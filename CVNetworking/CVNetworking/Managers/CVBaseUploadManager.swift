//
//  CVBaseUploadManager.swift
//  CVNetworking
//
//  Created by caven on 2018/11/30.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

open class CVBaseUploadManager: CVBaseManager {
    
    public weak var delegate: CVBaseManagerDelegate?
    public weak var child: CVUploadManagerChild?
    
    override init() {
        super.init()
        if let _ = self as? CVUploadManagerChild {
            self.child = self as? CVUploadManagerChild
        } else {
            assertionFailure("子类必须继承<CVBaseUploadManagerChild>协议")
        }
    }
}

// MARK: - Public Cycle
extension CVBaseUploadManager {
    public func upload() {
        return request()
    }
}

// MARK: - Private Cycle
fileprivate extension CVBaseUploadManager {
    
    func request() {
        
        
        guard self.child != nil else { return }
        
        let service = self.child!.service
        
        // 进行实际的网络请求, 先判断是否联网
        if service.isReachable {
            
            // 调起请求
            service.uploadFile(with: self.child!) { [weak self] (uploadRequest, error) in
                guard let `self` = self else { return }
                if uploadRequest != nil {       // 成功
                    uploadRequest!.uploadProgress(closure: { (progress) in
                        if progress.totalUnitCount != 0 {
                            print("\(progress.completedUnitCount / progress.totalUnitCount)")
                        }
                    })
                    uploadRequest!.response(completionHandler: { [weak self] (response) in
                        guard let `self` = self else { return }
                        if response.error == nil {
                            let response = CVURLResponse.init(data: response.data, requestID: uploadRequest!.task?.taskIdentifier ?? 0, request: response.request!, error: response.error)
                            response.effectiveParams = uploadRequest!.effectiveParams
                            response.fullParams = uploadRequest!.fullParams
                            print(response.responseObj)
                            self.handleSuccess(response: response)
                            self.delegate?.requestDidSuccess(response: response)
                        } else {
                            let response = CVURLResponse(error: response.error!)
                            self.handleFailed(response: response)
                            self.delegate?.requestDidFailed(response: response)
                        }
                    })

                    let requestID: Int = uploadRequest!.task?.taskIdentifier ?? 0
                    self.requestIDList.append(requestID)     // 记录请求ID
                    self.taskList.append(uploadRequest!.task!)
                } else {
                    // 失败
                    if let error = error as NSError? {
                        var errorType: CVNetworkingError = .others
                        switch error.code {
                        case 404:   errorType = .webNotFind
                        case 408:   errorType = .timeout
                        case 503:   errorType = .serviceNotAvaliable
                        default:    errorType = .others
                        }
                        
                        if service.handleError(error: error, errorType: errorType) {
                            let response = CVURLResponse(error: error)
                            response.error?.errorType = errorType
                            self.handleFailed(response: response)
                            self.delegate?.requestDidFailed(response: response)
                        }
                    }
                }
             }
            
        } else {
            
            // 没有网络
            let error = NSError(domain: service.baseURL, code: CVNetworkingError.noNetwork.rawValue, userInfo: [NSLocalizedDescriptionKey:"Loss network"]) as Error
            if service.handleError(error: error, errorType: .noNetwork) {
                let response = CVURLResponse(error: error)
                response.error?.errorType = .noNetwork
                self.handleFailed(response: response)
                self.delegate?.requestDidFailed(response: response)
            }
        }
    }
}

