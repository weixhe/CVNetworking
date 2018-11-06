//
//  CVNetCache.swift
//  CVNetworking
//
//  Created by caven on 2018/11/6.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class CVNetCache: NSObject {
    
    static let `default` = CVNetCache()
    
    let memoryCache = CVMemoryCache()
    let diskCache = CVDiskCache()
}

extension CVNetCache {
    
    /// 从内存读取
    public func fetchMemoryCache(identify: String, methodName: String, params: Dictionary<String, Any>) -> CVURLResponse? {
        return memoryCache.fetchCache(with: self.generateKey(identify: identify, methodName: methodName, params: params) as NSString)
    }
    
    /// 从硬盘读取
    public func fetchDiskCache(identify: String, methodName: String, params: Dictionary<String, Any>) -> CVURLResponse? {
        return diskCache.fetchCache(with: self.generateKey(identify: identify, methodName: methodName, params: params))
    }
    
    /// 保存到内存
    public func saveMemoryCache(response: CVURLResponse, identify: String, methodName: String, cacheTime: TimeInterval) {
        if response.content != nil, let param = response.originalRequestParams {
            let key = self.generateKey(identify: identify, methodName: methodName, params: param) as NSString
            memoryCache.saveCache(response: response, key: key, cacheTime: cacheTime)
        }
    }
    
    /// 保存到硬盘
    public func saveDiskCache(response: CVURLResponse, identify: String, methodName: String, cacheTime: TimeInterval) {
        if response.content != nil, let param = response.originalRequestParams {
            let key = self.generateKey(identify: identify, methodName: methodName, params: param)
            diskCache.saveCache(response: response, key: key, cacheTime: cacheTime)
        }
    }
    
    /// 清空内存
    public func cleanAllMemoryCache() {
        self.memoryCache.cleanAll()
    }
    
    /// 清空硬盘
    public func cleanAllDiskCache() {
        self.diskCache.cleanAll()
    }
}

// MARK: - 私有方法
private extension CVNetCache {
    
    /// 生成一个key
    func generateKey(identify: String, methodName: String, params: Dictionary<String, Any>) -> String {
        return identify + methodName + params.transformToUrlParamString()
    }
}
