//
//  CVMemoryCache.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

public class CVMemoryCache: NSObject {
    // MARK: - 属性
    
    private let cache = NSCache<NSString, CVCachedObject>()
    
    override init() {
        super.init()
        self.cache.countLimit = 5
    }
}

// MARK: - CVMemoryCache 公有方法
extension CVMemoryCache {
    
    /// 获取缓存, 如果缓存已过期，或者为空，则移除此缓存
    func fetchCache(with key: NSString) -> CVURLResponse? {
        if let cacheObj = self.cache.object(forKey: key) {
            if cacheObj.isOutdated || cacheObj.isEmpty {
                self.cache.removeObject(forKey: key)
            } else {
                return CVURLResponse(data: cacheObj.content!)
            }
        }
        return nil
    }
    
    /// 保存缓存，并设置缓存时间
    func saveCache(response: CVURLResponse, key: NSString, cacheTime: TimeInterval) {
        guard let data = response.data else { return }
        let cacheObj = self.cache.object(forKey: key) ?? CVCachedObject()
        
        cacheObj.cacheTime = cacheTime
        cacheObj.updateContent(data)
        
        self.cache.setObject(cacheObj, forKey: key)
    }
    
    /// 清空所有缓存
    func cleanAll() {
        self.cache.removeAllObjects()
    }
}


/**********************************************************************************/
/*                                CVCachedObject                                  */
/**********************************************************************************/

/// 本类为内存缓存的对象，其中保存了数据源，更新时间，缓存保留时间
class CVCachedObject: NSObject {
    private(set) var content: Data? {
        didSet {
            self.lastUpdateTime = NSDate.init(timeIntervalSinceNow: 0) as Date
        }
    }
    private(set) var lastUpdateTime: Date?      // 缓存最后一次更新时间
    var cacheTime: TimeInterval = 10       // 缓存保留时间，默认10s
    var isOutdated: Bool {      // 缓存是否已失效
        guard let lastUpdateTime = self.lastUpdateTime else { return false }
        let timeInterval = Date().timeIntervalSince(lastUpdateTime)
        return timeInterval > self.cacheTime
    }
    
    var isEmpty: Bool { return self.content == nil || self.content?.count == 0 }        // 缓存是否为空
    
    override init() {
        super.init()
    }
    
    /// 初始化：生成缓存对象，赋值data
    init(content: Data) {
        self.content = content
    }
    
    /// 更新缓存的内容
    func updateContent(_ content: Data) {
        self.content = content
    }
}



