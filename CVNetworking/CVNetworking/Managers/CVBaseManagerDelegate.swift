//
//  CVBaseApiManagerChild.swift
//  CVNetworking
//
//  Created by caven on 2018/11/20.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

/// 基础api管理者 子类 数据源
public protocol CVBaseManagerChild: NSObjectProtocol {
    var methodName: String { get }          // 请求的路径方法
    var paramters: [String: String] { get }    // 请求的参数
    var service: CVServiceProxy { get }     // 请求所使用的service的标识符
    var requestType: CVRequestType { get }  // 请求的方式： .get, .post, .put, .delete
    var headers: [String: String] { get }
    
}

// MARK: - 普通请求 child
public protocol CVDataManagerChild: CVBaseManagerChild {
    var config: CVConfiguration { get } // 相关配置
}

extension CVDataManagerChild {
    
    /// 使用默认的配置
    var config: CVConfiguration {
        return CVConfiguration()
    }
}

// MARK: - 上传文件 child
public protocol CVUploadManagerChild: CVBaseManagerChild {
    var uploadParams: [CVUploadParam] { get }
}


public protocol CVBaseManagerDelegate: NSObjectProtocol {
    
    /// 请求回调
    func requestDidSuccess(response: CVURLResponse)
    func requestDidFailed(response: CVURLResponse)
}
