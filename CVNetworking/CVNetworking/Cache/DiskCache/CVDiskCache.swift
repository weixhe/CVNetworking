//
//  CVDiskCache.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

private let cachePath = NSHomeDirectory() + "/Caches/CVNetworking/RequestData"
private let pathExtension = ".json"


class CVDiskCache: NSObject {
    
}
// MARK: - 公有方法
extension CVDiskCache {
    
    /// 获取缓存, 如果缓存已过期，或者为空，则移除此缓存
    func fetchCache(with key: String) -> CVURLResponse? {
        
        let filePath = cachePath + "/" + key + pathExtension
        do {
            let data = try NSData(contentsOfFile: filePath) as Data
            do {
                let fetchedContent = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                let lastUpdateTime = Date.init(timeIntervalSince1970: fetchedContent["lastUpdateTime"] as! TimeInterval)
                
                let timeInterval = Date().timeIntervalSince(lastUpdateTime)
                if timeInterval <= fetchedContent["cacheTime"] as! TimeInterval {
                    let responseStr = fetchedContent["content"] as? String
                    guard let string = responseStr else { return nil }
                    return CVURLResponse(data: string.data(using: String.Encoding.utf8)!)
                }
                
            } catch {
                CVNetLog(error.localizedDescription)
            }
        } catch {
            CVNetLog(error.localizedDescription)
        }
        
        return nil
    }
    
    /// 保存缓存，并设置缓存时间
    func saveCache(response: CVURLResponse, key: String, cacheTime: TimeInterval) {
        let data: Data?
        do {
            guard let _ = response.data else { return }
            data = try JSONSerialization.data(withJSONObject: [
                "content" : response.contentString,
                "lastUpdateTime" : Date().timeIntervalSince1970,
                "cacheTime" : cacheTime
            ], options: .prettyPrinted)
            if let dd = data {
                let filePath = cachePath + "/" + key + pathExtension
                createFolder(at: cachePath)
                createFile(at: filePath, for: dd)
            }
            
        } catch {
            CVNetLog(error.localizedDescription)
        }
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
    CVNetLog("网络缓存地址：\(path)")
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
