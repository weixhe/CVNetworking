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
    public func fetchMemoryCache(identifyer: String) -> CVURLResponse? {
        return memoryCache.fetchCache(with: identifyer as NSString)
    }
    
    /// 从硬盘读取
    public func fetchDiskCache(identifyer: String) -> CVURLResponse? {
        return diskCache.fetchCache(with: identifyer)
    }
    
    /// 保存到内存
    public func saveMemoryCache(response: CVURLResponse, identifyer: String, cacheTime: TimeInterval) {
        memoryCache.saveCache(response: response, key: identifyer as NSString, cacheTime: cacheTime)
    }
    
    /// 保存到硬盘
    public func saveDiskCache(response: CVURLResponse, identifyer: String, cacheTime: TimeInterval) {
        diskCache.saveCache(response: response, key: identifyer, cacheTime: cacheTime)
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
