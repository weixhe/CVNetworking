//
//  CVNetCache.swift
//  CVNetworking
//
//  Created by caven on 2018/11/6.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class CVNetCache: NSObject {
    
    static let share = CVNetCache()
    
    let memoryCache = CVMemoryCache()
    let diskCache = CVDiskCache()
}

extension CVNetCache {
    
    /// 从内存读取
    public func fetchMemoryCache(serviceIdentifier: String, methodName: String, params: Dictionary<String, Any>?) -> CVURLResponse? {
        return memoryCache.fetchCache(with: self.generateKey(serviceIdentifier: serviceIdentifier, methodName: methodName, params: params) as NSString)
    }
    
    /// 从硬盘读取
    public func fetchDiskCache(serviceIdentifier: String, methodName: String, params: Dictionary<String, Any>?) -> CVURLResponse? {
        return diskCache.fetchCache(with: self.generateKey(serviceIdentifier: serviceIdentifier, methodName: methodName, params: params))
    }
    
    /// 保存到内存
    public func saveMemoryCache(response: CVURLResponse, serviceIdentifier: String, methodName: String, cacheTime: TimeInterval) {
        let key = self.generateKey(serviceIdentifier: serviceIdentifier, methodName: methodName, params: response.effectiveParams) as NSString
        memoryCache.saveCache(response: response, key: key, cacheTime: cacheTime)
    }
    
    /// 保存到硬盘
    public func saveDiskCache(response: CVURLResponse, serviceIdentifier: String, methodName: String, cacheTime: TimeInterval) {
        let key = self.generateKey(serviceIdentifier: serviceIdentifier, methodName: methodName, params: response.effectiveParams)
        diskCache.saveCache(response: response, key: key, cacheTime: cacheTime)
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
    func generateKey(serviceIdentifier: String, methodName: String, params: Dictionary<String, Any>?) -> String {
        
        if params == nil {
            return serviceIdentifier + methodName
        }
        return serviceIdentifier + methodName + params!.transformToUrlParamString()
    }
}
