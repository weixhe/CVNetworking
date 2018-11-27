//
//  CVNetLog.swift
//  CVNetworking
//
//  Created by caven on 2018/11/6.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation

func CVNetLog<T>(_ message: T) {
    #if DEBUG
        print("\n/******************************************************************/\n")
        print("\(message)")
    #endif
}
