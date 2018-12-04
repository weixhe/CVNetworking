//
//  CVBaseManager.swift
//  CVNetworking
//
//  Created by caven on 2018/12/4.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

open class CVBaseManager: NSObject {
    public var requestIDList: [Int] = []
    public var taskList: [URLSessionTask] = []
}

// MARK: - Public Methods
extension CVBaseManager {
    /// 根据ID 取消请求
    public func cancelRequestID(_ requestID: Int) {
        if requestIDList.contains(requestID) {
            let index = (requestIDList as NSArray).index(of: requestID)
            let task = taskList[index]
            task.cancel()
            requestIDList.remove(at: index)
            taskList.remove(at: index)
        }
    }
    
    /// 取消所有请求
   public func cancelAll() {
        for task in taskList {
            task.cancel()
        }
        
        requestIDList.removeAll()
        taskList.removeAll()
    }
}

// MARK: - Public - Request result
extension CVBaseManager {
    /// 请求成功处理
    public func handleSuccess(response: CVURLResponse) {
        if requestIDList.contains(response.requestId) {
            let index = (requestIDList as NSArray).index(of: response.requestId)
            requestIDList.remove(at: index)
            taskList.remove(at: index)
        }
    }
    
    /// 请求失败处理
    public func handleFailed(response: CVURLResponse) {
        if requestIDList.contains(response.requestId) {
            let index = (requestIDList as NSArray).index(of: response.requestId)
            requestIDList.remove(at: index)
            taskList.remove(at: index)
        }
    }
}
