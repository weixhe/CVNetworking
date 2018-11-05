//
//  CVNetworkingError.swift
//  CVNetworkingError
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation


// MARK: - CVNetworkingError


public enum CVNetworkingError {
    
    /// 请求失败
    public enum RequestError {
        case success
        case cancel
        case timeout
        case noNetwork  // 默认除了超时以外的错误都是无网络错误。
    }
}
