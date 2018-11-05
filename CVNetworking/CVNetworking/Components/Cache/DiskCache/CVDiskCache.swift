//
//  CVDiskCache.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

let cachePath = NSHomeDirectory() + "/Caches/CVNetworking/Data"

class CVDisCache: NSObject {
    
}
// MARK: - 公有方法
extension CVDisCache {
    
//    /// 获取缓存, 如果缓存已过期，或者为空，则移除此缓存
//    func fetchCache(with key: NSString) -> CVURLResponse? {
//        if let cacheObj = self.cache.object(forKey: key) {
//            if cacheObj.isOutdated || cacheObj.isEmpty {
//                self.cache.removeObject(forKey: key)
//            } else {
//                return CVURLResponse(data: cacheObj.content!)
//            }
//        }
//        return nil
//    }
//    
//    /// 保存缓存，并设置缓存时间
//    func saveCache(response: CVURLResponse, key: NSString, cacheTime: TimeInterval) {
//        let cacheObj = self.cache.object(forKey: key) ?? CVCachedObject()
//
//        cacheObj.cacheTime = cacheTime
//        cacheObj.updateContent(response.responseData)
//
//        self.cache.setObject(cacheObj, forKey: key)
//    }
//
//    /// 清空所有缓存
//    func cleanAll() {
//        self.cache.removeAllObjects()
//    }
}
