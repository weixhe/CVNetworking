//
//  CVUploadParam.swift
//  CVNetworking
//
//  Created by caven on 2018/12/3.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation


// 文件的mineType ：http://www.iana.org/assignments/media-types/media-types.xhtml

enum CVMIMEType: String {
    case audio  = "audio/aac"
    case jpg    = "image/jpg"
    case jpeg   = "image/jpeg"
    case png    = "image/png"
    case txt    = "text/plain"
    case xml    = "text/xml"
    case html   = "text/html"
    case any    = "application/octet-stream"
}

public struct CVUploadParam {
    let fileData: Data
    let fileName: String          // 保存到服务器时对应的名字，可不设
    let serverName: String        // 服务器对应的字段名
    let MIMEType: String
    
    init(data: Data, fileName: String, serverName: String, MIMEType: CVMIMEType) {
        self.fileData = data
        self.fileName = fileName
        self.serverName = serverName
        self.MIMEType = MIMEType.rawValue
    }
}
