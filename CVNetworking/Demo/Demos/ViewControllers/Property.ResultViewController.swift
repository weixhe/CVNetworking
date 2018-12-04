//
//  Property.ResultViewController.swift
//  CVNetworking
//
//  Created by caven on 2018/11/21.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Setter & Getter
extension ResultViewController {
    
    func _viewModel() -> ResultViewModel {
        let VM = ResultViewModel(viewController: self)
        return VM
    }
    
    func _loginButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.frame = CGRect(x: 10, y: 10, width: 80, height: 40)
        btn.addTarget(self, action: #selector(onClickLoginAction(sender:)), for: .touchUpInside)
        return btn
    }
    
    func _homeButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.setTitle("Home", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.frame = CGRect(x: 100, y: 10, width: 80, height: 40)
        btn.addTarget(self, action: #selector(onClickHomeAction(sender:)), for: .touchUpInside)
        return btn
    }
    
    func _uploadHeaderButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.setTitle("Upload", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.frame = CGRect(x: 190, y: 10, width: 80, height: 40)
        btn.addTarget(self, action: #selector(onClickUploadHeaderAction(sender:)), for: .touchUpInside)
        return btn
    }
    
    func _crollView() -> UIScrollView {
        let sc = UIScrollView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height))
        sc.backgroundColor = UIColor.lightGray
        return sc
    }
    
    func _label() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = UIColor.brown
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }
    
    func _getResultData() -> String? {
        return label.text
    }
    
    func _setResultData(string: String?) {
        if var text = string {
            if text.count > 5000 {
                text = String(text.prefix(5000))
            }
            let height1 = height(for: text)
            scrollView.contentSize = CGSize(width: view.frame.width, height: height1)
            label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height1)
            label.text = text
        } else {
            label.text = "无结果"
        }
    }
    
}
