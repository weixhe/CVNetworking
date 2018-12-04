//
//  UploadImageManager.swift
//  CVNetworking
//
//  Created by caven on 2018/11/30.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import UIKit


class UploadImageManager: CVBaseUploadManager, CVUploadManagerChild {
    
    
    var uid: String!
    
    var uploadParams: [CVUploadParam] {
        let imageData = UIImage(named: "10_16.jpg")?.jpegData(compressionQuality: 0.5)
        guard imageData != nil else {
            return []
        }
        
        let param = CVUploadParam(data: imageData!, fileName: "a1.jpg", serverName: "image", MIMEType: CVMIMEType.jpeg)
        
        return [param]
    }
    
    
    var methodName: String {
        return "user/user_image?format=image"
    }
    
    var paramters: [String : String] { return ["uid":uid] }
    
    var service: CVServiceProxy { return MainUploadService.instance }
    
    var requestType: CVRequestType { return .post }
    
    var headers: [String : String] { return [:] }
}
