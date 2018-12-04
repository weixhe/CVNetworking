//
//  ResultViewController.swift
//  CVNetworking
//
//  Created by caven on 2018/11/20.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var dataString: String? {
        set { _setResultData(string: newValue) }
        get { return _getResultData() }
    }
    
    lazy var viewModel: ResultViewModel = { return _viewModel() }()
    
    lazy var loginBtn: UIButton = { return _loginButton() }()
    lazy var homeBtn: UIButton = { return _homeButton() }()
    lazy var uploadHeaderBtn: UIButton = { return _uploadHeaderButton() }()
    lazy var scrollView: UIScrollView = { return _crollView() }()
    lazy var label: UILabel = { return _label() }()
}

// MARK: - Life Cycle
extension ResultViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(loginBtn)
        view.addSubview(homeBtn)
        view.addSubview(homeBtn)
        view.addSubview(uploadHeaderBtn)
        view.addSubview(scrollView)
        scrollView.addSubview(label)
    }
}

// MARK: - Actions
extension ResultViewController {
    @objc func onClickLoginAction(sender: UIButton) {
        viewModel.loadLogin()
    }
    
    @objc func onClickHomeAction(sender: UIButton) {
        viewModel.loadHomeMsg()
    }
    
    @objc func onClickUploadHeaderAction(sender: UIButton) {
        viewModel.uploadImage()
    }
}

// MARK: - Private Methods
extension ResultViewController {
    func height(for text: String) -> CGFloat {
        let size = (text as NSString).boundingRect(with: CGSize(width: view.frame.width, height: 9999), options:  NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context: nil).size
        
        return size.height
    }
}


