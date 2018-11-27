//
//  CVConfiguration.swift
//  CVNetworking
//
//  Created by caven on 2018/11/23.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation


/// 一些网络请求的配置
public struct CVConfiguration {
    
    public var memoryCacheTime: TimeInterval = 3 * 60       // 内存缓存时间，默认：3分钟
    public var diskCacheTime: TimeInterval = 24 * 60 * 60   // 硬盘缓存时间，若为0，则为长期缓存
    
    public var cachePolicy: CVApiManagerCachePolicy = .noCache     // 缓存策略
    public var openCache: Bool = true      // 开启了缓存
    
    public var priority: CVNetworkingPriority = .required       // 默认每次都会请求
}


