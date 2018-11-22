//
//  ViewController.swift
//  CVNetworking
//
//  Created by caven on 2018/11/5.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

}

// MARK: - Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let label = UILabel(frame: CGRect(x: 0, y: (view.frame.height - 80) / 2, width: view.frame.width, height: 80))
        label.text = "Click me"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.blue
        label.textAlignment = .center
        view.addSubview(label)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(ResultViewController(), animated: true)
    }
}







