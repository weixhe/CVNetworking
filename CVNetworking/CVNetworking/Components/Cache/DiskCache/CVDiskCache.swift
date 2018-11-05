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

/// 创建文件夹
func createFolder(at path: String) {
    let manager = FileManager.default
    if !manager.fileExists(atPath: path) {
        do {
            // 创建文件夹: 1-路径, 2-是否补全中间的路劲, 3-属性
            try manager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            
        } catch let err as NSError {
            print(err.localizedDescription)
        }
    }
}

/// 创建一个文件
func writeFile(at path: String) {
    let manager = FileManager.default
    // 创建文件: 1-路径  2-内容 3-属性
    if manager.fileExists(atPath: path) {
        removeFilePath(at: path)
        
    }
    manager.createFile(atPath: path, contents: nil, attributes: nil)
}

func removeFilePath(at path: String) {
    
    let  manager = FileManager.default
    do {
        try manager.removeItem(atPath: path)
    } catch {
        print("creat false")
    }
}
