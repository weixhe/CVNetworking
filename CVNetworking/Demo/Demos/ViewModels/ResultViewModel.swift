//
//  ResultViewModel.swift
//  CVNetworking
//
//  Created by caven on 2018/11/21.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import UIKit

public class ResultViewModel: NSObject {
    
    private let loginManager: LoginApiManager = LoginApiManager()
    private var loginRequestID: Int = 0
    
    private let homeMsgManager: HomeMsgApiManager = HomeMsgApiManager()
    private var homeMsgRequestID: Int = 0
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        super.init()
        loginManager.delegate = self
        homeMsgManager.delegate = self
        self.viewController = viewController
    }
    
    public func loadLogin() {
        loginRequestID = loginManager.loadData()
        print("登录ID = \(loginRequestID)")
    }
    
    public func loadHomeMsg() {
        homeMsgRequestID = homeMsgManager.loadData()
        print("首页ID = \(homeMsgRequestID)")
    }
}


// MARK: - 请求结果
extension ResultViewModel: CVBaseApiManagerDelegate {
    func requestDidSuccess(response: CVURLResponse) {
        
        if response.requestId == loginRequestID {
            (viewController as! ResultViewController).dataString = "登录成功" + response.contentString
        } else if response.requestId == homeMsgRequestID {
            (viewController as! ResultViewController).dataString = "首页数据成功" + response.contentString
        }
    }
    
    func requestDidFailed(response: CVURLResponse) {
        if response.requestId == loginRequestID {
            (viewController as! ResultViewController).dataString = "登录失败" + response.contentString
        } else if response.requestId == homeMsgRequestID {
            (viewController as! ResultViewController).dataString = "首页数据失败" + response.contentString
        }
    }
}
