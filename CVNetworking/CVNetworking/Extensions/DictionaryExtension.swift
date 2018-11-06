//
//  DictionaryExtension.swift
//  CVNetworking
//
//  Created by caven on 2018/11/6.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 将字典中的数据转换成，拼接成一个字符串
    func transformToUrlParamString() -> String {
        var result = ""
        
        var index = 0
        for (key, value) in self {
            if index == 0 {
                result = "?\(key)=\(value)"
            } else {
                result += "&\(key)=\(value)"
            }
            index += 1
        }
        return result
    }
}
