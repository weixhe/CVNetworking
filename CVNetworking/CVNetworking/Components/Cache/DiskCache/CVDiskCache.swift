//
//  CVDiskCache.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

private let cachePath = NSHomeDirectory() + "/Caches/CVNetworking/RequestData"
private let pathExtension = ".bast"


class CVDiskCache: NSObject {
    
}
// MARK: - 公有方法
extension CVDiskCache {
    
    /// 获取缓存, 如果缓存已过期，或者为空，则移除此缓存
    func fetchCache(with key: String) -> CVURLResponse? {
        
//        let filePath = cachePath + "/" + key + pathExtension
        let pathUrl = Bundle.main.url(forResource: key, withExtension: pathExtension, subdirectory: cachePath)
        guard let url = pathUrl else { return nil }
        
        do {
            let data = try Data.init(contentsOf: url)
            do {
                let fetchedContent = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                let lastUpdateTime = Date.init(timeIntervalSince1970: fetchedContent["lastUpdateTime"] as! TimeInterval)
                
                let timeInterval = Date().timeIntervalSince(lastUpdateTime)
                if timeInterval <= fetchedContent["cacheTime"] as! TimeInterval {
                    return CVURLResponse(data: fetchedContent["content"] as! Data)
                }
                
            } catch let error as NSError {
                CVNetLog(error.localizedDescription)
            }
        } catch let error as NSError {
            CVNetLog(error.localizedDescription)
        }
        
        return nil
    }
    
    /// 保存缓存，并设置缓存时间
    func saveCache(response: CVURLResponse, key: String, cacheTime: TimeInterval) {
        let data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: [
                "content" : response.responseData,
                "lastUpdateTime" : Date().timeIntervalSince1970,
                "cacheTime" : cacheTime
            ], options: JSONSerialization.WritingOptions.prettyPrinted)
            if let dd = data {
                let filePath = cachePath + "/" + key + pathExtension
                createFolder(at: cachePath)
                createFile(at: filePath, for: dd)
            }
            
        } catch let error as NSError {
            CVNetLog(error.localizedDescription)
        }
        CVNetLog("在catch以后看看是否执行")
    }

    /// 清空所有缓存
    func cleanAll() {
        removeFilePath(at: cachePath)
    }
}

/// 创建文件夹
func createFolder(at path: String) {
    let manager = FileManager.default
    if !manager.fileExists(atPath: path) {
        do {
            // 创建文件夹: 1-路径, 2-是否补全中间的路劲, 3-属性
            try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            
        } catch let error as NSError {
            CVNetLog(error.localizedDescription)
        }
    }
}

/// 创建一个文件
func createFile(at path: String, for contents: Data) {
    let manager = FileManager.default
    // 创建文件: 1-路径  2-内容 3-属性
    if manager.fileExists(atPath: path) {
        removeFilePath(at: path)
    }
    manager.createFile(atPath: path, contents: contents, attributes: nil)
}

func removeFilePath(at path: String) {
    
    let  manager = FileManager.default
    do {
        try manager.removeItem(atPath: path)
    } catch {
        CVNetLog("creat false")
    }
}
