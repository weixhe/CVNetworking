//
//  CVNetLog.swift
//  CVNetworking
//
//  Created by caven on 2018/11/6.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

func CVNetLog<T>(_ message: T, fileName: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        let logStr = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: "swift", with: "")
        print("/***********************************************/")
        print("类：\(logStr) \n 方法：\(method) \n 行数：\(line) \n 数据：\(message)")
    #endif
}


extension CVURLResponse {
    func logString() -> String {

        var logString = ""
        
#if DEBUG
        print("\n\n=====================\nAPI Response\n=====================\n\n")
        logString = "1"
        
#endif
        
        return logString
    }
}
