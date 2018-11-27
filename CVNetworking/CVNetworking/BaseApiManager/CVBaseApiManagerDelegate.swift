//
//  CVBaseApiManagerChild.swift
//  CVNetworking
//
//  Created by caven on 2018/11/20.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

/// 基础api管理者 子类 数据源
public protocol CVBaseApiManagerChild: class {
    
    var methodName: String { get }  // 请求的路径方法
    var paramters: [String: Any] { get }   // 请求的参数
    var service: CVServiceDelegate { get }   // 请求所使用的service的标识符
    var requestType: CVRequestType { get } // 请求的方式： .get, .post, .put, .delete
    var headers: [String: String] { get }
    
    /// 接口版本，若service中同样设置了版本，则使用这里的字段
    var apiVersion: String { get }
    
    var config: CVConfiguration { get } // 相关配置
    
}

extension CVBaseApiManagerChild {
    
    /// 使用默认的配置
    var config: CVConfiguration {
        return CVConfiguration()
    }
}



public protocol CVBaseApiManagerDelegate: class {
    
    /// 请求回调
    func requestDidSuccess(response: CVURLResponse)
    func requestDidFailed(response: CVURLResponse)
}
